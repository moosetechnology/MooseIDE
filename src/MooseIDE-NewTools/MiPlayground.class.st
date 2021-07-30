Class {
	#name : #MiPlayground,
	#superclass : #StPlayground,
	#category : #'MooseIDE-NewTools-Playground'
}

{ #category : #accessing }
MiPlayground class >> defaultTitle [ 

	^ 'Midas Playground'
]

{ #category : #'instance creation' }
MiPlayground class >> open [ 
	<script>
	^ self new openWithSpec
]

{ #category : #'instance creation' }
MiPlayground >> toolbarActions [
	^ super toolbarActions
		register: (MiPlaygroundInstalledModelsCommand forSpecContext: self);
		yourself
]
