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

	Example:
		aFAMIXClass queryAllOutgoing.
			--> Will return a MooseOutgoingQueryResult containing the FAMIXAssociation having aFAMIXClass or its children as source
	"
	
	| dependencies |
	dependencies := self queryAllOutgoing.
	self addDeclaredTypesIn: dependencies.
	^ dependencies
]

{ #category : #'*MooseIDE-Dependency' }
TEntityMetaLevelDependency >> rootsForTreeMap [

	^ self asMooseGroup
]
