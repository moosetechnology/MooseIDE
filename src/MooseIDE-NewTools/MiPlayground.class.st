Class {
	#name : #MiPlayground,
	#superclass : #StPlayground,
	#category : #'MooseIDE-NewTools-Playground'
}

{ #category : #accessing }
MiPlayground class >> defaultTitle [ 

	^ 'MooseIDE Playground'
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
	^ self new openWithSpec
]

{ #category : #'instance creation' }
MiPlayground >> newDefaultPlaygroundPage [

	^ MiPlaygroundPage new
]
