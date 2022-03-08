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

{ #category : #'instance creation' }
MiDMBrowser class >> title [ 

	^ 'Distribution map'
]
