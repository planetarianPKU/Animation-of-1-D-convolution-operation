a = [zeros(1,100) 1 zeros(1,100) 0:0.005:0.25 zeros(1,100)  0:0.005:0.25 0.25:-0.005:0  zeros(1,100) 2 zeros(1,100) 0.125:0.005:0.25 zeros(1,100) 3 zeros(1,100) 0.25:-0.005:0.125 zeros(1,100) 0.25:0.005:0 zeros(1,100) 2 zeros(1,100) 1 zeros(1,100)];
t = -2:0.1:2; hdur = 1;
sig_input = 2*(hdur*sqrt(pi))^(-1).*exp(-(t/hdur).^2);

pulse_last = [];
conv_result = [];

%video
name_forward = 'conv_video_test.avi';
out = VideoWriter(name_forward);
out.FrameRate=10;
open(out)

%loop
for i = 1:length(a)
    if i == 1 
      pulse = a(i).*sig_input;
      pulse_last = pulse;
    else
      pulse =  a(i).*sig_input;
      pulse(1:end-1) = pulse(1:end-1) + pulse_last(2:end);
      pulse_last = pulse;
    end
    
    i_step = pulse(1);
    conv_result = [conv_result i_step];
    %plot
    subplot(21,1,[1:10]);
    plot(a,'lineWidth',5,'color','white')
    hold on;plot([zeros(1,i-1) sig_input],'color','red','LineWidth',5);  
    hold on;plot([i i + length(sig_input) i + length(sig_input) i i],[-0.2 -0.2 5 5 -0.2],'--','LineWidth',3,'color','yellow')
    xlim([0 length(a)+length(sig_input)]);ylim([-0.5 5])
    set(gca,'LineWidth',5)
    set(gcf,'color','black')
    set(gca,'Fontsize',40);
    set(gca,'Visible','off'); 
    
    subplot(21,1,[11:21]);
    plot(conv_result,'LineWidth',5,'color','red');
    hold on;plot(i,i_step+1,'v','Markersize',20,'Markeredgecolor','yellow','markerfacecolor','red','LineWidth',5);    xlim([0 1300]);
    ylim([-0.5 5]);xlim([0 length(a)+length(sig_input)]);
    xlabel('Time')
    set(gca,'LineWidth',5)
    set(gcf,'color','black')
    set(gca,'Fontsize',40);
    set(gca,'Visible','off'); 
    
    %capture
    F=getframe(gcf);
    writeVideo(out, F);
    clf
end
close(out);
conv_result = [conv_result(1:end-1) pulse];