"
I am a moose entity bus to which registered browsers can ""write"" and ""read"" entities
"
Class {
	#name : #MiBus,
	#superclass : #Object,
	#instVars : [
		'name',
		'browsers',
		'logger'
	],
	#category : #'MooseIDE-Core-Application'
}

{ #category : #'instance creation' }
MiBus class >> named: aName [
	^ self new
		name: aName;
		yourself
]

{ #category : #accessing }
MiBus >> browsers [
	^ browsers
]

{ #category : #actions }
MiBus >> globallySelect: anEntity [
	anEntity
		ifNotNil: [ (self logger newLogFor: anEntity) activateIn: self ]
]

{ #category : #initialization }
MiBus >> initialize [
	super initialize.
	browsers := Set new.
	logger := MiLogger new
]

{ #category : #accessing }
MiBus >> logger [
	^ logger
]

{ #category : #accessing }
MiBus >> name [
	^ name
]

{ #category : #accessing }
MiBus >> name: anObject [
	name := anObject
]

{ #category : #actions }
MiBus >> refreshBrowsersWith: anEntity [
	self browsers do: [ :browser | browser receiveEntity: anEntity ]
]

{ #category : #actions }
MiBus >> registerBrowser: aBrowser [
	browsers add: aBrowser
]

{ #category : #actions }
MiBus >> unregisterBrowser: aBrowser [
	browsers remove: aBrowser
]
