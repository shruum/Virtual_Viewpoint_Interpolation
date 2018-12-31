function [new_im_dst, chist_dst, chist_ref, map, M] = cumulative_histogram_mapping(im_dst, im_ref, edges)

% image color correction using cumulatie histogram mapping

[N,d] = size(im_ref);
   
for i=1:d
    cens{i} = (edges{i}(1:end-1)+edges{i}(2:end))/2;    
    chist_dst{i} = compute_cumulative_histogram(im_dst(:,i), edges{i});
    chist_ref{i} = compute_cumulative_histogram(im_ref(:,i), edges{i});
    
    [map{i}, M{i}] = map_cumulative_histograms(chist_dst{i}, chist_ref{i}, edges{i}, cens{i}, im_ref(:,i));
end

new_im_dst = convert_image(im_dst, map, edges);

%%%%%%%%%%%%%%%%%%%%%%%%%%% compute cumulative histogram

function chist = compute_cumulative_histogram(data, edges)

data = double(data(:));

H = histc(data, edges); 
H = H(1:end-1);  % discard the last fake bin
nhist = H/sum(H);  % normalized histogram
chist = cumsum(nhist);

%%%%%%%%%%%%%%%%%%%%%%%%%%% mapping function

function [map, M] = map_cumulative_histograms(chist_dst, chist_ref, edges, cens, im_ref)

n = length(chist_dst);

M = zeros(n,1);
t = 1;  % searching starting point
for v=1:n
    chist_diff = chist_ref - chist_dst(v);
    idx = find(chist_diff<=0);
    if isempty(idx)
        M(v) = 1;
    else
        M(v) = idx(end);
    end
end

% convert from index mapping to value mapping
for i=1:n
    map(i) = cens(M(i));
end

%%%%%%%%%%%%%%%%%%%%%% applying the mapping function to get the converted image

function new_im = convert_image(im, map, edges)

[N,d] = size(im);
new_im = zeros(N,d);

for i=1:d  % for each channle
    curr_map = map{i};
    curr_edges = edges{i};
    
    for j=1:length(curr_map)  % for each histgram bin
        idx = find(curr_edges(j)<=im(:,i) & im(:,i)<curr_edges(j+1));
        new_im(idx,i) = curr_map(j);
    end
end


