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
