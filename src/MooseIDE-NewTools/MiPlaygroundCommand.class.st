Class {
	#name : #MiPlaygroundCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-NewTools-Playground'
}

{ #category : #accessing }
MiPlaygroundCommand >> application [

	^ MiApplication current
]
