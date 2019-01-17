
import sys;
sys.path.append( "R:\T\PythonScipy\modules" );

import PIL;
import PIL.Image

def stretchdown( imagein, yrow, addrows ):
	yrow = int( yrow );
	addrows = int( addrows )
	if addrows > 0:
		im = PIL.Image.new( "RGBA", ( imagein.size[0], imagein.size[1] + addrows ), None )
		
		yslice = PIL.Image.new( "RGBA", ( imagein.size[0], 1 ), None )
		yslice.paste( imagein.crop( ( 0, yrow, imagein.size[0], yrow+1 ) ), (0,0) )
		
		yslice = yslice.resize( (imagein.size[0], addrows ), PIL.Image.NEAREST )
		
		im.paste( yslice, (0, yrow) )
			
		im.paste( imagein.crop( ( 0, 0, imagein.size[0], yrow+1 ) ), (0,0) )
		im.paste( imagein.crop( ( 0, yrow, imagein.size[0], imagein.size[1] ) ), (0,im.size[1] - yrow) )
		
		return im;
	return imagein;
	
def stretchright( imagein, xcol, addcols ):

	pass;


def generate( mode_width, mode_height, left_cut, right_cut, images ):

	im_header = images["header"];
	im_footer = images["footer"];
	im_body = images["body"];
	im_item = images["item"];
	im_itemicon = images["itemicon"];
	im_itemover = images["itemover"];
	im_itemiconover = images["itemiconover"];

	#Construct HEADER image
	imh = PIL.Image.new( "RGBA", ( left_cut+right_cut+mode_width, im_header.size[1] ), None )
	imh.paste( im_header.crop( ( 0,0,left_cut,im_header.size[1] ) ), (0,0) )
	imh.paste( im_header.crop( ( im_header.size[0]-right_cut,0,im_header.size[0],im_header.size[1] ) ), (imh.size[0] - right_cut,0) )
	
	ix = left_cut
	ixmax = imh.size[0] - right_cut
	xslice = im_header.crop( ( ix,0,ix+1,im_header.size[1] ) );
	while ix < ixmax:
		imh.paste( xslice, (ix,0) )
		ix += 1;
		
	imh.save("out/gen_header_"+str(mode_width)+".png", "PNG")
	
	#Construct FOOTER image
	imf = PIL.Image.new( "RGBA", ( left_cut+right_cut+mode_width, im_footer.size[1] ), None )
	imf.paste( im_footer.crop( ( 0,0,left_cut,im_footer.size[1] ) ), (0,0) )
	imf.paste( im_footer.crop( ( im_footer.size[0]-right_cut,0,im_footer.size[0],im_footer.size[1] ) ), (imf.size[0] - right_cut,0) )
	
	ix = left_cut
	ixmax = imf.size[0] - right_cut
	xslice = im_footer.crop( ( ix,0,ix+1,im_footer.size[1] ) );
	while ix < ixmax:
		imf.paste( xslice, (ix,0) )
		ix += 1;
		
	imf.save("out/gen_footer_"+str(mode_width)+".png", "PNG")
	
	#Construct ITEM image
	
	lineheight = 0;
	lineheightsize = 10;
	
	while lineheight < 8:
	
		#Stretch all images FROM HALF downard by lineheight*8 pixels..
		exstring = ""
		if lineheight > 0 :
			exstring = "_"+str(lineheight+1);
		
		imageitem = PIL.Image.new( "RGBA", ( left_cut+right_cut+mode_width - 8, im_item.size[1] ), None )
		imageitem.paste( im_item.crop( ( 0,0,left_cut,im_item.size[1] ) ), (0,0) )
		imageitem.paste( im_item.crop( ( im_item.size[0]-right_cut,0,im_item.size[0],im_item.size[1] ) ), (imageitem.size[0] - right_cut,0) )
		
		ix = left_cut
		ixmax = imageitem.size[0] - right_cut
		xslice = im_item.crop( ( ix,0,ix+1,im_item.size[1] ) );
		while ix < ixmax:
			imageitem.paste( xslice, (ix,0) )
			ix += 1;
			
		imageitem = stretchdown( imageitem, int(imageitem.size[1]/2), lineheight * lineheightsize )
		imageitem.save("out/gen_item_"+str(mode_width)+exstring+".png", "PNG")
		
		
		imageicon = PIL.Image.new( "RGBA", ( left_cut+right_cut+mode_width - 8, im_itemicon.size[1] ), None )
		imageicon.paste( im_itemicon.crop( ( 0,0,left_cut+16,im_itemicon.size[1] ) ), (0,0) )
		imageicon.paste( im_itemicon.crop( ( im_itemicon.size[0]-right_cut,0,im_itemicon.size[0],im_itemicon.size[1] ) ), (imageicon.size[0] - right_cut,0) )
		
		ix = left_cut+16
		ixmax = imageicon.size[0] - right_cut
		xslice = im_itemicon.crop( ( ix,0,ix+1,im_itemicon.size[1] ) );
		while ix < ixmax:
			imageicon.paste( xslice, (ix,0) )
			ix += 1;
			
		imageicon = stretchdown( imageicon, int(imageicon.size[1]/2), lineheight * lineheightsize )
		imageicon.save("out/gen_itemicon_"+str(mode_width)+exstring+".png", "PNG")
		
		
		
		imageitemover = PIL.Image.new( "RGBA", ( left_cut+right_cut+mode_width - 8, im_itemover.size[1] ), None )
		imageitemover.paste( im_itemover.crop( ( 0,0,left_cut,im_itemover.size[1] ) ), (0,0) )
		imageitemover.paste( im_itemover.crop( ( im_itemover.size[0]-right_cut,0,im_itemover.size[0],im_itemover.size[1] ) ), (imageitemover.size[0] - right_cut,0) )
		
		ix = left_cut
		ixmax = imageitemover.size[0] - right_cut
		xslice = im_itemover.crop( ( ix,0,ix+1,im_itemover.size[1] ) );
		while ix < ixmax:
			imageitemover.paste( xslice, (ix,0) )
			ix += 1;
			
		imageitemover = stretchdown( imageitemover, int(imageitemover.size[1]/2), lineheight * lineheightsize )
		imageitemover.save("out/gen_itemover_"+str(mode_width)+exstring+".png", "PNG")
		
		
		imageiconover = PIL.Image.new( "RGBA", ( left_cut+right_cut+mode_width - 8, im_itemiconover.size[1] ), None )
		imageiconover.paste( im_itemiconover.crop( ( 0,0,left_cut+16,im_itemiconover.size[1] ) ), (0,0) )
		imageiconover.paste( im_itemiconover.crop( ( im_itemiconover.size[0]-right_cut,0,im_itemiconover.size[0],im_itemiconover.size[1] ) ), (imageiconover.size[0] - right_cut,0) )
		
		ix = left_cut+16
		ixmax = imageiconover.size[0] - right_cut
		xslice = im_itemiconover.crop( ( ix,0,ix+1,im_itemiconover.size[1] ) );
		while ix < ixmax:
			imageiconover.paste( xslice, (ix,0) )
			ix += 1;
			
		imageiconover = stretchdown( imageiconover, int(imageiconover.size[1]/2), lineheight * lineheightsize )
		imageiconover.save("out/gen_itemiconover_"+str(mode_width)+exstring+".png", "PNG")
		
		lineheight += 1
	
	
	#Construct BODY image
	im = PIL.Image.new( "RGBA", ( imh.size[0], mode_height ), None )
	yslice = PIL.Image.new( "RGBA", ( imh.size[0], 1 ), None )
	
	yslice.paste( im_body.crop( ( 0,0,left_cut,1 ) ), (0,0) )
	yslice.paste( im_body.crop( ( im_body.size[0]-right_cut,0,im_body.size[0],1 ) ), (im.size[0] - right_cut,0) )
	
	ix = left_cut
	ixmax = imh.size[0] - right_cut
	xslice = im_body.crop( ( ix,0,ix+1,1 ) );
	while ix < ixmax:
		yslice.paste( xslice, (ix,0) )
		ix += 1;
		
	iy = 0
	iymax = im.size[1]
	while iy <= iymax:
		im.paste( yslice, (0, iy) )
		iy += 1;
	im.save("out/gen_body_"+str(mode_width)+"_"+str(mode_height)+".png", "PNG")
	

def run():

	header_name = "header_48.png"
	footer_name = "footer_48.png"
	body_name = "body_48.png"
	item_name = "listitem_48.png"
	itemicon_name = "listitemicon_64.png"
	itemover_name = "listitemover_48.png"
	itemiconover_name = "listitemiconover_64.png"

	images = {}
	images["header"] = PIL.Image.open( header_name )
	images["footer"] = PIL.Image.open( footer_name )
	images["body"] = PIL.Image.open( body_name )
	images["item"] = PIL.Image.open( item_name )
	images["itemicon"] = PIL.Image.open( itemicon_name )
	images["itemover"] = PIL.Image.open( itemover_name )
	images["itemiconover"] = PIL.Image.open( itemiconover_name )

	left_cut = 6+1;
	right_cut = 14+1;

	#Iterate through some modes:
	modequant = 32;
	
	mode_width = modequant;
	mode_height = modequant;
	
	mode_width_max = 10*modequant;
	mode_height_max = 15*modequant;
	
	mode_height = modequant;
	while mode_height < mode_height_max:
	
		mode_width = modequant;
		while mode_width < mode_width_max:
		
			generate( mode_width, mode_height, left_cut, right_cut, images )
	
			mode_width = mode_width + modequant
		mode_height = mode_height + modequant
	
	generate( mode_width, mode_height, left_cut, right_cut, images )

	print("yeah");

if __name__	== "__main__":
	sys.exit(run())
