function field = read_rfield(fid,fieldname,dims)


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
if numin ~= prod(dims)
    error('read_rfield: inconsistent number of input elements: prod = %d, file = %d\n',prod(dims),numin);
end

% Read the data
field = fscanf(fid,'%e',prod(dims));
if (length(dims) > 1)
    field = reshape(field,dims);
end