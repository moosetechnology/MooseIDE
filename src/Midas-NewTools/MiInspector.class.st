Class {
	#name : #MiInspector,
	#superclass : #StInspector,
	#category : #'Midas-NewTools-Inspector'
}

{ #category : #'private - factory' }
MiInspector >> newInspectorFor: aModel [

	| newInspector |
	newInspector := self
		                instantiate: MiObjectInspectorPresenter
		                on: aModel asInspectorModel.
	self class inspectorDiveOnSingleClick ifTrue: [ 
		newInspector activateOnSingleClick ].

	millerList pages ifNotEmpty: [ :pages | 
		newInspector
			whenClosedDo: [ millerList removeAllFrom: newInspector ];
			"select last shown page (or default)"trySelectAnyPageWithName: { 
					lastPageSelectedTabName.
					pages last selectedPageName }
		"prepare to close" ].

	^ newInspector
]
