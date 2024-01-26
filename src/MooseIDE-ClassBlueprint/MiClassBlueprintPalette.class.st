Class {
	#name : #MiClassBlueprintPalette,
	#superclass : #MiPalette,
	#category : #'MooseIDE-ClassBlueprint'
}

{ #category : #style }
MiClassBlueprintPalette >> beDefaultStyle [

	self
		addName: #isAbstract
		forColor: Color cyan darker darker darker duller;
		addName: #'isOverriding(redefined locally and no super)'
		forColor: (Color fromHexString: '#996800') duller;
		addName: #'isOverridden(redefined in subclasses)'
		forColor: Color palePeach;
		addName: #isDelegating
		forColor: Color yellow darker duller slightlyWhiter;
		addName: #'isExtending(invoke method via super)'
		forColor: Color orange darker duller;
		addName: #isInternalImplementation forColor: Color purple;
		addName: #isTestMethod forColor: Color pink;
		addName: #isDeadMethod forColor: Color veryDarkGray;
		addName: #isConstant forColor: Color lightGray;
		addName: #'isSetter or isGetter'
		forColor: Color magenta duller duller slightlyWhiter;
		addName: #isLazyInitializer forColor: Color yellow muchDarker;
		addName: #isOther forColor: Color white;
		addName: #Attribute forColor: Color blue;
		addName: #'Attribute accessed by subclass(es) of this class'
		forColor: Color green muchDarker duller;
		addName: #'isAbstract and reimplemented in subclass(es)'
		forColor: nil;
		addName: #'Tested Method' forColor: nil;
		addName: #'Cyclomatic Complexity' forColor: nil;
		addName: #'Monomorphic Method' forColor: nil;
		addName: #'Polymorphic Method' forColor: nil;
		addName: #'Megamorphic Method' forColor: nil
]

{ #category : #initialization }
MiClassBlueprintPalette >> initialize [

	super initialize.
	self beDefaultStyle
]
