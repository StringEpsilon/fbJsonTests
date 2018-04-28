#include once "../fbJson.bas"

sub GetFiles( files() as string )
	dim as string filename
	dim as integer i
	redim files(0)

	filename = dir("testfiles/*")
	do until filename = ""
		i += 1
		redim preserve files(i)
		files(i) = filename
		filename = dir("")
	loop
end sub

function readFile(filename as string) as string
	dim jsonString as string
	dim as integer ff = freefile()

	open "testfiles/" & filename for binary as #ff 
	jsonString = space(lof(ff))
	get #ff, , jsonString
	close #ff

	jsonString = trim(jsonString, any " "+chr(9,10))
	return jsonString
end function

dim files() as string
dim item as jsonItem 
dim failures as integer = 0
GetFiles files()

for i as integer = 1 to ubound(files) -1 
	
	if (files(i)[0] = asc("n") ) then
		item = jsonItem( readfile(files(i)) )
		if item.datatype <> malformed then
			print "Expected jsom to be malformed, but isn't.", files(i)
			print ">"&readfile(files(i))&"<"
		end if
	elseif (files(i)[0] = asc("y") ) then
		item = jsonItem( readfile(files(i)) )
		if item.datatype = malformed then
			print "Expected jsom to be valid, but isn't.", files(i)
			print item.toString()
			print ">"&readfile(files(i))&"<"
		end if
	else
		' TODO: Sort remainign "i_" files.
	end if
next

print
sleep
