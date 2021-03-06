
clear all;


gt_path='/media/r/dataset/rain/Rain100L/';

BRN = '../result/BRN/R100L/output/';
BRNRX = '../result/BRN-RX/R100L/output/';
BRNXR = '../result/BRN-XR/R100L/output/';
CRN = '../result/CRN/R100L/output/';

 
struct_model = {
          struct('model_name','BRN','path',BRN),...
          struct('model_name','BRN-RX','path',BRNRX),...
          struct('model_name','BRN-XR','path',BRNXR),...
          struct('model_name','CRN','path',CRN),...
	};

nimgs=100;nrain=1;
nmodel = length(struct_model);

psnrs = zeros(nimgs,nmodel);
ssims = psnrs;

for nnn = 1:nmodel
    
    tp=0;ts=0;te=0;
    nstart = 0;
    for iii=nstart+1:nstart+nimgs
        for jjj=1:nrain
            %         fprintf('img=%d,kernel=%d\n',iii,jjj);
            x_true=im2double(imread(fullfile(gt_path,sprintf('norain-%03d.png',iii))));%x_true
            x_true = rgb2ycbcr(x_true);x_true=x_true(:,:,1);
            

            %%
            x = (im2double(imread(fullfile(struct_model{nnn}.path,sprintf('rain-%03d.png',iii)))));
            x = rgb2ycbcr(x);x = x(:,:,1);
            tp = mean(psnr(x,x_true));
            ts = ssim(x*255,x_true*255);
            
            psnrs(iii-nstart,nnn)=tp;
            ssims(iii-nstart,nnn)=ts;
            
            %
        end
    end
    
    fprintf('%s: psnr=%6.4f, ssim=%6.4f\n',struct_model{nnn}.model_name,mean(psnrs(:,nnn)),mean(ssims(:,nnn)));
    
end




