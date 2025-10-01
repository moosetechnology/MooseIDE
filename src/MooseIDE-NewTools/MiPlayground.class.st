"
I am a custom playground for Moose.
I include a **Models** toolbar button. It is used to insert an expression to assign a model to a variable.
"
Class {
	#name : 'MiPlayground',
	#superclass : 'StPlaygroundPresenter',
	#category : 'MooseIDE-NewTools-Playground',
	#package : 'MooseIDE-NewTools',
	#tag : 'Playground'
}

{ #category : 'private - factory' }
MiPlayground >> newDefaultPlaygroundPage [

	^ MiPlaygroundPage new
]
