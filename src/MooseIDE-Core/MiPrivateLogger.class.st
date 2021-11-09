"
I am a logger for a PrivateBus, i.e. a bus associated to a workspace and its contained browser(s)

I only keep one log entry, the last one
"
Class {
	#name : #MiPrivateLogger,
	#superclass : #MiLogger,
	#category : #'MooseIDE-Core-Logger'
}

{ #category : #'instance creation' }
MiPrivateLogger >> newLogFor: anEntity [
	self clean.
	^super newLogFor: anEntity
]
