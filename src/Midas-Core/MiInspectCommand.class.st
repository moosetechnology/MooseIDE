"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #MiInspectCommand,
	#superclass : #CmCommand,
	#category : #'Midas-Core-Command'
}

{ #category : #default }
MiInspectCommand class >> defaultName [
	^ 'Inspect'
]

{ #category : #default }
MiInspectCommand class >> forSpecContext: anObject [
	^ (self forSpecWithIconNamed: #mooseIcon) beHiddenWhenCantBeRun
]

{ #category : #testing }
MiInspectCommand >> canBeExecuted [
	^ self context miSelectedItem isMooseEntity
]

{ #category : #testing }
MiInspectCommand >> execute [
	^ self context miSelectedItem inspect
]
