"
As my superclass, I am used in playgrounds to access bindings.
I am specific to Moose.
"
Class {
	#name : 'MiPlaygroundInteractionModel',
	#superclass : 'StPlaygroundInteractionModel',
	#category : 'MooseIDE-NewTools-Playground',
	#package : 'MooseIDE-NewTools',
	#tag : 'Playground'
}

{ #category : 'as yet unclassified' }
MiPlaygroundInteractionModel >> application [

	^ MiApplication current
]
