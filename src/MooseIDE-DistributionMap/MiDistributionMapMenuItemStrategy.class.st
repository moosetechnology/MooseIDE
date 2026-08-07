Class {
	#name : 'MiDistributionMapMenuItemStrategy',
	#superclass : 'HDefaultMenuItemStrategy',
	#category : 'MooseIDE-DistributionMap-Menu',
	#package : 'MooseIDE-DistributionMap',
	#tag : 'Menu'
}

{ #category : 'public' }
MiDistributionMapMenuItemStrategy >> classFor: aRoassalShape [

	aRoassalShape isShape ifFalse: [ ^ MiDistributionMapMenuItem ].
	^ aRoassalShape isNode
		  ifTrue: [ MiDistributionMapNodeMenuItem ]
		  ifFalse: [ MiDistributionMapMenuItem ]
]

{ #category : 'public' }
MiDistributionMapMenuItemStrategy >> menuItemClassesFor: aShape [
	"Unlike MiButterflyMenuItemStrategy, no inspect item is appended here:
	 MiDistributionMapInspectNodeMenuItem is already a subclass of
	 MiDistributionMapNodeMenuItem, so it's already included via #subclasses."

	^ (self classFor: aShape) subclasses
]
