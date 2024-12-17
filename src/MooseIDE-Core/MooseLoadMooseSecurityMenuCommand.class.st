"
A command to load Moose-Security in the image.

This project goal is to help find security vulnerabilities in projects using Moose. We tag the vulnerabilities and visualize them.

https://github.com/moosetechnology/Moose-Security
"
Class {
	#name : #MooseLoadMooseSecurityMenuCommand,
	#superclass : #MooseAbstractLoadToolMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseLoadMooseSecurityMenuCommand class >> label [

	^ 'Moose Security'
]

{ #category : #'world menu' }
MooseLoadMooseSecurityMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self menuCommandOn: aBuilder forCommand: self
]

{ #category : #accessing }
MooseLoadMooseSecurityMenuCommand class >> menuPriority [

	^ super menuPriority + 3
]

{ #category : #accessing }
MooseLoadMooseSecurityMenuCommand >> baselineName [

	^ 'MooseSecurity'
]

{ #category : #accessing }
MooseLoadMooseSecurityMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/MooseSecurity:' , self version , '/src'
]

{ #category : #accessing }
MooseLoadMooseSecurityMenuCommand >> version [

	^ 'main'
]
