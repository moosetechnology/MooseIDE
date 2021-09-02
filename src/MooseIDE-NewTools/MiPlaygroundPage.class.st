Class {
	#name : #MiPlaygroundPage,
	#superclass : #StPlaygroundPage,
	#category : #'MooseIDE-NewTools-Playground'
}

{ #category : #'inspector compatibility' }
MiPlaygroundPage >> defaultObjectInspectorClass [

	^ MiPlaygroundPagePresenter
]
