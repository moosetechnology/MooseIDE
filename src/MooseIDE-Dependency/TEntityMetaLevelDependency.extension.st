Extension { #name : #TEntityMetaLevelDependency }

{ #category : #'*MooseIDE-Dependency' }
TEntityMetaLevelDependency >> miTreeExtension [

	<inspectorPresentationOrder: 15 title: 'Tree'>
	^ SpTreeTablePresenter new
		  addColumn: (SpCompositeTableColumn new
				   addColumn: ((SpImageTableColumn evaluated: #midasIcon)
						    width: 20;
						    yourself);
				   addColumn: (SpStringTableColumn evaluated: #name);
				   yourself);
		  children: [ :aClass | aClass children asOrderedCollection ];
		  beMultipleSelection;
		  roots: { self };
		  beResizable
]

{ #category : #'*MooseIDE-Dependency' }
TEntityMetaLevelDependency >> rootsForTreeMap [

	^ self asMooseGroup
]
