"
I am a custom playground for Moose.
I include a **Models** toolbar button. It is used to insert an expression to assign a model to a variable.
"
Class {
	#name : #MiPlayground,
	#superclass : #StPlayground,
	#category : #'MooseIDE-NewTools-Playground'
}

{ #category : #accessing }
MiPlayground class >> defaultTitle [ 

	^ 'Moose Playground'
]

{ #category : #'class initialization' }
MiPlayground class >> initialize [

	"Make playground active by default"

	self register
]

{ #category : #'world menu' }
MiPlayground class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (MooseModel developerTool: self menuCommandOn: aBuilder)
		  order: 10;
		  help: 'Playground enhanced for usage in Moose';
		  yourself
]

{ #category : #'world menu' }
MiPlayground class >> menuLabel [

	^ 'Moose Playground'
]

{ #category : #'instance creation' }
MiPlayground class >> open [

	<script>
	^ self new open
]

{ #category : #'private - factory' }
MiPlayground >> newDefaultPlaygroundPage [

	^ MiPlaygroundPage new
]
