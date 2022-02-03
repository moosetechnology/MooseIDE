Extension { #name : #MiCoTagVisualization }

{ #category : #'*MooseIDE-CoUsageMap-Browser' }
MiCoTagVisualization >> tagsFromMooseModel: aMooseModel [
	| ctag group |
	self removeOldLegend.
	ctag := aMooseModel tagNamed: 'Need work'.
	group := aMooseModel allTags sorted: [ :a :b | a name < b name ].
	self conflictTag: ctag asMiCoTag.
	group 
		reject: [ :tag | tag = ctag ] 
		thenDo: [ :tag | self addTag: tag asMiCoTag ].
]
