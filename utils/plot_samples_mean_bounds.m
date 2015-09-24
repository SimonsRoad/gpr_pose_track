function plot_samples_mean_bounds(fig,x,y,mean_pred,sigma_pred)
% Plots a picture given true x, true y, mean prediction and sigma bounds
set(fig,'defaulttextinterpreter','latex');
h1 = plot(x,y,'+',...
    x,mean_pred,'g-',...
    x,mean_pred+2*sigma_pred,'r--','Linewidth',3);
hold on;
h2 = plot(x,mean_pred-2*sigma_pred,'r--','Linewidth',3);
xlabel('X $\rightarrow$','FontSize',14);
ylabel('Y $\rightarrow$','FontSize',14);
legend([h1],{'Samples','Fit','95% Bounds'},'location','NorthWest');
set(gca,'FontSize',14);
end