Extension { #name : 'HSimpleVisualizationBuilder' }

{ #category : '*MooseIDE-Core' }
HSimpleVisualizationBuilder >> updateTags [
	"'redraw' all shapes so that new tags can be displayed if nodeStyler wants
	 need to unselect all shapes before because this raises error"

	container setSelectedShapes: RSGroup new.

	container shapes do: [ :sh |
		sh isLine ifFalse: [
			self rebuildShape: sh
		]
	].

]
