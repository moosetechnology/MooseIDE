Extension { #name : #TEntityMetaLevelDependency }

{ #category : #'*MooseIDE-Dependency' }
TEntityMetaLevelDependency >> miTreeExtension [

	<inspectorPresentationOrder: 15 title: 'Tree'>
	^ SpTreeTablePresenter new
		  addColumn: (SpCompositeTableColumn new
				   addColumn: ((SpImageTableColumn evaluated: #mooseIcon)
						    width: 20;
						    yourself);
				   addColumn: (SpStringTableColumn evaluated: #name);
				   yourself);
		  children: [ :aClass | aClass children ];
		  beMultipleSelection;
		  roots: { self };
		  beResizable
]

{ #category : #'*MooseIDE-Dependency' }
TEntityMetaLevelDependency >> queryAllOutgoingForDSM [
	"Query all the outgoing associations of the receiver and its children.
	 This is a special implementation that catches more dependencies.
	 For example it gets the declaredType of variables.
	 This is temporary until we resolve the issue of declaredType not being an Association"
	
	| dependencies |
	dependencies := self queryAllOutgoing.
	self addNonAssociationDependenciesTo: dependencies.
	^ dependencies
]

{ #category : #'*MooseIDE-Dependency' }
TEntityMetaLevelDependency >> rootsForTreeMap [

	^ self asMooseGroup
]
