Extension { #name : #SettingTreeBuilder }

{ #category : #'*MooseIDE-CoUsageMap' }
SettingTreeBuilder >> miDualRange: aSymbol [
	^ self nodeClass: MiCoDualRangeSettingDeclaration name: aSymbol
]

{ #category : #'*MooseIDE-CoUsageMap' }
SettingTreeBuilder >> miRange: aSymbol [
	^ self nodeClass: MiCoRangeSettingDeclaration name: aSymbol
]
