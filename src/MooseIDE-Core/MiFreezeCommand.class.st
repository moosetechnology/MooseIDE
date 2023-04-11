"
I represent a command corresponding to a freeze button in browsers.
This command allows to ignore changes pushed by the bus.
"
Class {
	#name : #MiFreezeCommand,
	#superclass : #MiReceivingModeCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiFreezeCommand class >> defaultDescription [
	^ 'A mode that allows to ignores changes pushed on the bus'
]

{ #category : #default }
MiFreezeCommand class >> defaultName [

	^ 'Freeze'
]

{ #category : #accessing }
MiFreezeCommand >> iconName [

	^ self iconNameForState: self context canFollow not
]

{ #category : #accessing }
MiFreezeCommand >> receivingMode [

	^ MiFreezeMode
]
