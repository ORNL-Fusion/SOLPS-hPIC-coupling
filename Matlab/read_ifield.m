function field = read_ifield(fid,fieldname,dims)

% Search the file until identifier 'fieldname' is found
line = fgetl(fid);
while isempty(strfind(line,fieldname))
    line = fgetl(fid);
    if line == -1
        error(['EOF reached without finding ',fieldname,'.']);
    end
end

% Consistency check: number of elements specified in the file should equal
% prod(dims)
numin = strread(line,'%*s %*s %d');
if numin == 0
%     warning('Variable %s has 0 size\n',fieldname)
    field = [];
    return;
end
if numin ~= prod(dims)
    error('read_ifield: inconsistent number of input elements.');
end

% Read the data
field = fscanf(fid,'%d',prod(dims));
if (length(dims) > 1)
    field = reshape(field,dims);
end