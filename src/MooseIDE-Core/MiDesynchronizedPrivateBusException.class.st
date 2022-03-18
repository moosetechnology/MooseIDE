"
This exception is raised when a private bus never received any object from its browser.

It is raised chen trying to access the most recent entity of a private bus. See MiShallowLogger.
After an object is propagated on the private bus, even if this object is nil, this exception should not be raised.
"
Class {
	#name : #MiDesynchronizedPrivateBusException,
	#superclass : #MiException,
	#category : #'MooseIDE-Core-Exception'
}

{ #category : #initialization }
MiDesynchronizedPrivateBusException >> initialize [

	super initialize.
	messageText := 'Private bus did never receive any entity.
	The browser should always send selected entities to private bus'
]
