"
I am a custom `StPlaygroundPage` with custom defaultObjectInspectorClass. I am used by `MiPlayground`.
"
Class {
	#name : #MiPlaygroundPage,
	#superclass : #StPlaygroundPage,
	#category : #'MooseIDE-NewTools-Playground'
}

{ #category : #'inspector compatibility' }
MiPlaygroundPage >> defaultObjectInspectorClass [

	^ MiPlaygroundPagePresenter
]
