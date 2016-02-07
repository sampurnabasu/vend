import urllib       
import json  
import time     
import datetime        
import serial                                                        
from timeout import timeout    

@timeout(2)        #timeout if http problem  
def callApi():      #function to get information from firebase server          
    #print 'test1'                                       
    time.sleep(.2)           
    urlStr = "https://project-vend.firebaseio.com/.json" #link for my firebase server                       
    try:
        print 'try'
        #proxies = {'http': '189.112.3.87:3128','http' : '208.254.241.13:8080'} #using proxy     
        fileObj = urllib.urlopen(urlStr, proxies=None)  #get string content from the website       
        #print 'test2'                                   
        for line in fileObj: #iterate through lines in the website                     
            #print line 
            print line                                  
            releaseCandy=[]                           
            parsed_json = json.loads(line) #parse the string in json format                                                                                                      
            releaseCandy.append(parsed_json['Nutri-Grain'])                                                                              
            releaseCandy.append(parsed_json['Oreos'])       
            releaseCandy.append(parsed_json['Peanuts'])      
            releaseCandy.append(parsed_json['Skittles'])                                                                
            return releaseCandy
    except:
        print 'calling'
        return []

def main():
    ser = serial.Serial('/dev/cu.usbmodem1421', 19200)

    #wait until connected
    connected=False
    while not connected:
        print 'not connected'
        serin = ser.read()
        connected = True
    print 'connected'

    while 1:
        try:   #try catch block for debugging                          
            time.sleep(.95)                                      
            curOpen=callApi()  #get the information from firebase server   

            if curOpen==[]: #failed GET call earlier
                print 'not connected'   
                continue                       
            print "good"                    #print good to know the we got the data from server successfully
            count=0
            for ind,value in enumerate(curOpen):
                print ind,value
                if int(value) == 1:
                    ser.write(chr(ind+1+ord('0')))
                    print chr(ind+1+ord('0'))
                    count+=1
                    break
            if count==0:
                ser.write('0')
        except:    #check for exception
            print 'waiting'
            #print "bad"
        time.sleep(1)                                                 

if __name__ == "__main__":
    main()