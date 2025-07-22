Extension { #name : 'FamixCBAbstractSeverity' }

{ #category : '*MooseIDE-CriticBrowser' }
FamixCBAbstractSeverity class >> droplistDisplayString [

	^ String streamContents: [ :s |
		  s
			  << self title;
			  << ' (Level = ';
			  << self level asString;
			  << ')' ]
]
