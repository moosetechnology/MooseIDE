Extension { #name : #TLRoassal3Connector }

{ #category : #'*MooseIDE-Telescope' }
TLRoassal3Connector >> open: aTLVisualization inCanvas: aCanvas [
	| lb |
	self view: aCanvas.
	view @ RSCanvasController new noLegend.
	view @ TLDragPointCanvas.
	aTLVisualization generateWith: self.
	lb := self legendBuilder.
	lb shapes ifNotEmpty: [ lb build ].
]
