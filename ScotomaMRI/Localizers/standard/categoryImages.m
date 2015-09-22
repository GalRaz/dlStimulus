function imgList = categoryImages(varargin);% imgList = categoryImages(categories,[options]);%% returns a list of image files for the specified category/categories.  %% categories can be a string containing one category name, or % a cell-of-strings containing several category names. For a list of % acceptable category names, see categoryDirs.%% imgList is a cell-of-strings, containing paths relative to the imageDB, % unless the 'fullpath' option is set,  in which case the full path of each % image will be returned. % % If several categories of image are specified, the images will be concatenated % in the output list.  Images will also be shuffled, unless the 'noshuffle' option is %specified.%% Dependencies: categoryDirs, imageDB.%% first written for masking expt 4: stim strength/priming.%% 10/03 ras.% 02/16/04 ras -- now recursively adds subdirectories.% 04/2006 sod - ignore all hidden '.' directoriesif nargin < 1	help categoryImages    returnend%%%%% parametersstripPathFlag = 1;shuffleFlag = 0;recursionFlag = 1;% be ready to accept nested cells in inputsvarargin = unNestCell(varargin);cat = varargin;%%%%% parse the optionsfor i = 1:length(varargin)	if ischar(varargin{i})        switch lower(varargin{i})		case 'fullpath',			stripPathFlag = 0;			cat = {varargin{1:i-1} varargin{i+1:end}};		case 'noshuffle',			shuffleFlag = 0;			cat = {varargin{1:i-1} varargin{i+1:end}};		case 'shuffle',			shuffleFlag = 1;			cat = {varargin{1:i-1} varargin{i+1:end}};		case 'norecursion',			recursionFlag = 0;			cat = {varargin{1:i-1} varargin{i+1:end}};		otherwise,			% ignore		end    endenddirList = {};for i = 1:length(cat)	dirList = [dirList categoryDirs(cat{i})'];endif recursionFlag==1 % find subdirectories and look in them	cnt = 1;	while (cnt <= length(dirList)) & (cnt<50)		w = dir(dirList{cnt});		for j = 1:length(w)            % if w(j).isdir & ~ismember(w(j).name,{'.' '..'})            % also ignore hidden files			if w(j).isdir & ~ismember(w(j).name(1),{'.'})				dirList{end+1} = fullfile(dirList{cnt},w(j).name);			end		end		cnt = cnt + 1;	endend				%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% generate list of image files%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%imgList = {};cnt = 1;for i = 1:length(dirList)	nextdir = dirList{i};	fprintf('%s ...\n',nextdir);	w = filterdir('.jpg',nextdir);	numfiles = length(w);	for j = 1:numfiles		imgList{cnt} = fullfile(dirList{i},w(j).name);		cnt = cnt + 1;	endendif stripPathFlag	% paths will be specified relative to the imageDB path:	% remove the beginning of each path, which specifies imageDB location	n = length(imageDB) + 1;	for i = 1:length(imgList)		imgList{i} = imgList{i}(n:end);	endendif shuffleFlag	% shuffle image order	imgList = shuffle(imgList);end% looks nicer as a column vector imgList = imgList(:);return