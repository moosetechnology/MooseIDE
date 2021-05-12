Extension { #name : #Object }

{ #category : #'*Midas-NewTools' }
Object >> inspect [

	"Create and schedule an Inspector in which the user can examine the receiver's variables."

	^ self isMooseObject
		  ifTrue: [ MiInspectorBrowser inspect: self ]
		  ifFalse: [ Smalltalk tools inspector inspect: self ]
]
