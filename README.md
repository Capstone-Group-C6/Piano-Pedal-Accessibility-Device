# Piano-Pedal-Accessibility-Device (PPAD)
Northeastern University Capstone 2023 Open Source Repository for our PPAD system. Software designed by Roberto Chadwick, Lucas Laya Marina, and Luke Wisner. Hardware designed by Hanchen Liu, Josh Moffat, and Tristan Siu.

### General Overview
This project provides a way for people with a disability to use their piano pedals by tracking their head tilt and replicating it as pedal presses. The app is only for iOS devices, as we used Apple's Vision Library to get the necessary head tracking data. We wanted to make our work open-source so that anyone could make this device for themselves or anyone they know who would like the ability to use their piano pedals. Through the device that you plug into the piano port and the iOS application, we have created a system that can replicate pedal presses for one or three pedals. 

This idea began as a way to help Jonathan Goodwin for our engineering capstone project. Jonathan is a retired stunt performer and a current keynote speaker. Follow him at: https://www.instagram.com/jonathangoodwinofficial/?hl=en

Jonathan loves to play the piano, but he is unable to use the pedals because he was paralyzed from the waist down in an accident. We set out to create a device that would allow him to once again get full use from his piano. Through our initial meetings with Jonathan, we were able to discern the simplest, most intuitive way to make that possible: using the tilt of his head. The solutions that exist today all require the user to bite down on or blow into a device, but that would prevent Jonathan from being able to sing when he plays. The head tilt became the perfect solution because it fixed this issue while remaining intuitive to the user.

## Hardware
### Hardware Overview
One half of the PPAD system is the device that plugs into the back of the piano and replicates the pedal press signal. Anyone who wants to use this design in the future will need a chip capable of sending and recieving data over bluetooth (we used an ESP32 as a relatively inexpensive option so our schematics match that). In addition, they will need a way to power the device through micro-USB and connect the device to their piano pedal port using 1/4-inch jacks.

### Hardware Replication
The necessary KiCad files (schematic and PCB layout) have been added to allow anyone to replicate our board for their own personal use. The following images display the schematic design as well as the PCB layout of the components and traces involved in integrating all the parts of the board. [insert image 1] [insert image 2] In terms of the manufacturing and assembly process, orders can be made through various PCB manufacturers (we used JLCPCB.com) and provide them with our PCB/schematic files to make an order. Below is the part list with links to sites to purchase each component. (NOTE: You can also import the provided files into the KiCad project manager to view/make any changes to the project) In terms of assembly, be sure to solder on the components that are not already assembled onto the board from the manufacturer (i.e. 1/4" sockets...).

Parts List:
- 1/4" Socket: https://www.amazon.com/dp/B07MR2TT3Q?psc=1&smid=A34H4GNHCXU7L2&ref_=chk_typ_imgToDp
- LEDs: [maybe link? not really]
- ESP32 Chip: [link]
- Switch: [link]

### Three Pedal Proprietary Cable
To use three pedals with the device, a new

## Software
### Software Overview
The other half of the PPAD system

### Firmware Overview

### Bluetooth Connection

### Head Tracking

### Navigating Settings

### Software Replication
To replicate the software, the user will need to flash the firmware onto the chip they have started using. 

## Additional Implementations 
Another reason that we wanted to make this code publiclly available is that it has so many other applications to help anyone with disabilities. We designed the app with a piano in mind, but the code can be repurposed to work with another instrument such as a guitar or drumset. Further beyond this, the head tracking functions could be expanded upon to communicate with non-instrument devices like a wheelchair. We hope that this code can help any who use it!
