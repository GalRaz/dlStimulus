from math import *
from random import *
from numpy import *
from scipy import ndimage
import matplotlib.pyplot as plt
import matplotlib.cm as cm

def DakinModel(number=0,density=0,area=0):
 
    #input-dependent parameters
       
    if number!=0 and density !=0 and area!=0:
        raise Exception('Specify max. 2 parameters')
    
    if number==0 and density==0 and area==0:
        dots_A=randint(50,150)
        dots_B=randint(50,150)
        a=arange(200,400,2)
        squaresize_A=a[randint(1,len(a))]
        squaresize_B=a[randint(1,len(a))]
        
    if number!=0 and area==0 and density==0: 
        dots_A=number #use given number
        dots_B=dots_A
        a=arange(200,400,2)
        squaresize_A=a[randint(1,len(a))]
        squaresize_B=a[randint(1,len(a))]
        
        
    if area !=0 and number==0 and density==0: 
        dots_A=randint(50,150)
        dots_B=randint(50,150)
        if ceil(sqrt(area))%2==0:
            squaresize_A=ceil(sqrt(area))
        else: 
            squaresize_A=floor(sqrt(area))
        squaresize_B=squaresize_A
    
    if density!=0 and area==0 and number==0: 
        dots_A=randint(50,150) 
        dots_B=randint(50,150)
        if ceil(sqrt(dots_A/density))%2==0:
            squaresize_A=ceil(sqrt(dots_A/density))
        else: 
            squaresize_A=floor(sqrt(dots_A/density))
        
        if ceil(sqrt(dots_B/density))%2==0:
            squaresize_B=ceil(sqrt(dots_B/density))
        else: 
            squaresize_B=floor(sqrt(dots_B/density))
    
    if density!=0 and area!=0:
        dots_A=int(area*density)
        dots_B=dots_A
        if ceil(sqrt(area))%2==0:
            squaresize_A=ceil(sqrt(area))
        else: squaresize_A=floor(sqrt(area))
        squaresize_B=squaresize_A
        
    if density!=0 and number!=0: 
        dots_A=number
        dots_B=dots_A
        if ceil(sqrt(dots/density))%2==0:
            squaresize_A=ceil(sqrt(dots_A/density))
        else: squaresize_A=floor(sqrt(dots_A/density)) #calc. squaresize given density&number
        squaresize_B=squaresize_A
        
    if number!=0 and area!=0:
        dots_A=number
        dots_B=dots_A
        if ceil(sqrt(area))%2==0:
            squaresize_A=ceil(sqrt(area))
        else: squaresize_A=floor(sqrt(area))
        squaresize_B=squaresize_A
        
    #fixed parameters 
    
    imagesize=600
    dotradius=imagesize/200 
    
    #all possible positions (2 by imagesize^2 array)
    a=arange(1,imagesize+1,1)
    Xpos,Ypos=meshgrid(a,a)
    X=reshape(Xpos,(imagesize**2,1))
    Y=reshape(Ypos,(imagesize**2,1))
    
    PosMatrix=hstack([X,Y]) #all possible positions
    
    #all possible positions for dots (2 by squaresize^2 array) Image_A
    
    aB=arange(imagesize/2-squaresize_A/2,imagesize/2+squaresize_A/2,1)
    XposB,YposB=meshgrid(aB,aB)
    XB=reshape(XposB,(squaresize_A**2,1))
    YB=reshape(YposB,(squaresize_A**2,1))
    
    DotPosMatrix=hstack([XB,YB]) #all possible positions for dots
    DotPos=array([])
    
    
    #choosing dot  positions
    
    for x in range (0,dots_A): #determine dot positions

        CurrentPos = DotPosMatrix[randint(1,int(shape(DotPosMatrix)[0]))] #random index from possible position
   
        DotPos = concatenate([DotPos,CurrentPos]) #list positions
       
        DotPosMatrix = DotPosMatrix[hypot(DotPosMatrix[:,0] - CurrentPos[0], DotPosMatrix[:,1] - CurrentPos[1])>2*dotradius] #reduce possible positions based on previous points


    Image_A=zeros((imagesize,imagesize)) #middle gray background
    DotPos=DotPos.astype(int)
   
    #fill dots and all coordinates within dotradius
   
    for x in range (0,dots_A):
            
            FillDots=PosMatrix[hypot(PosMatrix[:,0] - DotPos[2*(x+1)-2], PosMatrix[:,1] - DotPos[2*(x+1)-1])<dotradius] #find coordinates that are within the radius
            
            FillDots=FillDots.astype(int) #integer indices

            if x%2==0:
                Image_A[FillDots[:,0],FillDots[:,1]] = -1 #every even white 
            if x%2!=0:
                Image_A[FillDots[:,0],FillDots[:,1]] = 1 #every uneven black


    #second image

    #all possible positions for dots (2 by squaresize^2 array) Image_B
    
    aB=arange(imagesize/2-squaresize_B/2,imagesize/2+squaresize_B/2,1)
    XposB,YposB=meshgrid(aB,aB)
    XB=reshape(XposB,(squaresize_B**2,1))
    YB=reshape(YposB,(squaresize_B**2,1))
    
    DotPosMatrix=hstack([XB,YB]) #all possible positions for dots
    DotPos=array([])

    for x in range (0,dots_B): #determine dot positions

        CurrentPos = DotPosMatrix[randint(1,int(shape(DotPosMatrix)[0]))] #random index from possible position
   
        DotPos = concatenate([DotPos,CurrentPos]) #list positions
       
        DotPosMatrix = DotPosMatrix[hypot(DotPosMatrix[:,0] - CurrentPos[0], DotPosMatrix[:,1] - CurrentPos[1])>2*dotradius] #reduce possible positions based on previous points


    Image_B=zeros((imagesize,imagesize)) #middle gray background
    DotPos=DotPos.astype(int)
   
    #fill dots and all coordinates within dotradius
   
    for x in range (0,dots_B):
            
            FillDots=PosMatrix[hypot(PosMatrix[:,0] - DotPos[2*(x+1)-2], PosMatrix[:,1] - DotPos[2*(x+1)-1])<dotradius] #find coordinates that are within the radius
            
            FillDots=FillDots.astype(int) #integer indices

            if x%2==0:
                Image_B[FillDots[:,0],FillDots[:,1]] = -1 #every even white 
            if x%2!=0:
                Image_B[FillDots[:,0],FillDots[:,1]] = 1 #every uneven black


    #parameter output A
    print("For Image A")
    print("number of dots =",dots_A)
    print("patch density =",dots_A/squaresize_A**2*1000, "* 10^-3 dots per square pixel")
    print("patch area =",squaresize_A**2, "square pixel")
    
     #parameter output B
    print("")
    print("For Image B")
    print("number of dots =",dots_B)
    print("patch density =",dots_B/squaresize_B**2*1000, "* 10^-3 dots per square pixel")
    print("patch area =",squaresize_B**2, "square pixel")
    
    #plot image A
    ax=plt.subplot("321")
    ax.imshow(Image_A,cmap = cm.Greys_r)
    ax.set_title("Original A")
    ax.axis('off')
    
    #plot image B
    ax=plt.subplot("322")
    ax.imshow(Image_B,cmap = cm.Greys_r)
    ax.set_title("Original B")
    ax.axis('off')
    
    #image rectification
    Image_A=abs(Image_A)
    Image_B=abs(Image_B)
    

    #kernel size and grid for values 
    hi_s=0.2
    low_s=1.2
    a=arange(-floor(low_s*4.5),ceil(low_s*4.5)+0.1,0.1)
    [X,Y] = meshgrid(a,a);
   
    #kernels (Laplacian of Gaussian)
    Vlow = 1/(pi*low_s**4) * (1- (X**2 + Y**2)/(2*low_s**2)) * exp(-((X**2 + Y**2))/(2*low_s**2));
    Vhi = 1/(pi*hi_s**4) * (1- (X**2 + Y**2)/(2*hi_s**2)) * exp(-((X**2 + Y**2))/(2*hi_s**2));
     
    #convolution of image with kernels and second rectification
    lowpass_A = abs(ndimage.convolve(Image_A, Vlow))
    highpass_A = abs(ndimage.convolve(Image_A, Vhi))
    lowpass_B = abs(ndimage.convolve(Image_B, Vlow))
    highpass_B = abs(ndimage.convolve(Image_B, Vhi))
    
    #plot highpass and lowpass
    ax=plt.subplot("323")
    ax.imshow(highpass_A,cmap=cm.Greys_r)
    ax.set_title("Highpass filter A")
    ax.axis('off')

    ax=plt.subplot("325")
    ax.imshow(lowpass_A,cmap=cm.Greys_r)
    ax.set_title('Lowpass filter A')
    ax.axis('off')

    ax=plt.subplot("324")
    ax.imshow(highpass_B,cmap=cm.Greys_r)
    ax.set_title("Highpass filter B")
    ax.axis('off')

    ax=plt.subplot("326")
    ax.imshow(lowpass_B,cmap=cm.Greys_r)
    ax.set_title('Lowpass filter B')
    ax.axis('off')

    #Response ratio
    resratio_A=sum(highpass_A)/sum(lowpass_A)*float(random.normal(1,0.01,1)) #smaller random noise for now
    resratio_B=sum(highpass_B)/sum(lowpass_B)*float(random.normal(1,0.01,1)) 
    
    print("")
    #relative density estimate
    estimated_density=resratio_A/resratio_B
    print("relative density estimate =",estimated_density)    

    if estimated_density>1:
        print("Model says A is more dense")
    else:
        print("Model says B is more dense")
        
    print("")
    
    #relative numerosity estimate
    estimated_numerosity=(float(random.normal(1,0.05,1))*sum(lowpass_A)/sum(lowpass_B))**float(random.normal(1,1.9,1))*estimated_density
    print("relative numerosity estimate =",estimated_numerosity)
 
    if estimated_numerosity>1:
        print("Model says A is more numerous")
    else:
        print("Model says B is more numerous")
        
    print("")    
    print("lowpass response A =",sum(lowpass_A))
    print("lowpass response B =",sum(lowpass_B))
    print("")
    print("highpass response A =",sum(highpass_A))
    print("higpass response B =",sum(highpass_B))

    #reference patch compared to 10 images with same numerosity
    #look into other methods of convolution (Fourier?)
    #Dehaene model
