"
I am a browser that display a distribution map.
I am composed of two main elements :
- a form, that allows user to enter settings of the distribution map
- a canvas, on which the disribution map is drawn
"
Class {
	#name : #MiDMBrowser,
	#superclass : #MiHierarchicalMapBrowser,
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #accessing }
MiDMBrowser class >> mapClass [

	^ MiDM
]

{ #category : #'instance creation' }
MiDMBrowser class >> open [
	<script>
	super open
]

{ #category : #accessing }
MiDMBrowser class >> openExemple [
	<script>
	| mapModel |
	mapModel := MiHierarchicalMapModel new childrenBlock: [ :node | node classes ]; yourself.
	mapModel addDynamicTag: (MiDynamicTag new name:  '1'; query: [ :node | node numberOfMethods <= 1 ]).
	mapModel addDynamicTag: (MiDynamicTag new name:  '2 <> 5'; query: [ :node | node numberOfMethods between: 2 and: 5 ]).
	mapModel addDynamicTag: (MiDynamicTag new name:  '6 <> 15'; query: [ :node | node numberOfMethods between: 6 and: 15 ]).
	mapModel addDynamicTag: (MiDynamicTag new name:  '16 <> 50'; query: [ :node | node numberOfMethods between: 16 and: 50 ]).
	mapModel addDynamicTag: (MiDynamicTag new name:  '> 50'; query: [ :node | node numberOfMethods > 50 ]).
	^ (self on:  mapModel)
		  openWithSpec;
		  followBus: self currentApplication defaultBus;
		  yourself
]

{ #category : #'instance creation' }
MiDMBrowser class >> title [ 

	^ 'Distribution map'
]
