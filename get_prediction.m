function prediction = get_prediction(B,T,K)

w = B*bsxfun(@minus,T,mean(T));
b = mean(T - K*w);

prediction = bsxfun(@plus,K*w,b);

end
