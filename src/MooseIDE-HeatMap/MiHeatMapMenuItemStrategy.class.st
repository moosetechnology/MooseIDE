Class {
	#name : 'MiHeatMapMenuItemStrategy',
	#superclass : 'HDefaultMenuItemStrategy',
	#category : 'MooseIDE-HeatMap-Menu',
	#package : 'MooseIDE-HeatMap',
	#tag : 'Menu'
}

{ #category : 'public' }
MiHeatMapMenuItemStrategy >> classFor: aRoassalShape [

	aRoassalShape isShape ifFalse: [ ^ MiHeatMapMenuItem ].
	^ aRoassalShape isNode
		  ifTrue: [ MiHeatMapNodeMenuItem ]
		  ifFalse: [ MiHeatMapMenuItem ]
]

{ #category : 'public' }
MiHeatMapMenuItemStrategy >> menuItemClassesFor: aShape [
	"Unlike MiButterflyMenuItemStrategy, no inspect item is appended here:
	 MiHeatMapInspectNodeMenuItem is already a subclass of
	 MiHeatMapNodeMenuItem, so it's already included via #subclasses."

	^ (self classFor: aShape) subclasses
]
