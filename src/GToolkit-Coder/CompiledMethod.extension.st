Extension { #name : #CompiledMethod }

{ #category : #'*GToolkit-Coder' }
CompiledMethod >> gtBrowseFrom: anElement [
	| aSpace aCoder packagesCoder |
	packagesCoder := GtPackagesCoder new.
	aCoder := GtInspector withToolOn: packagesCoder.
	aSpace := BlSpace new.
	aSpace title: 'Coder'.
	aSpace extent: 1200 @ 600.
	aSpace addChild: aCoder.
	aSpace withHalos.
	anElement showSpace: aSpace.
	packagesCoder withSelectedMethod: self
]

{ #category : #'*GToolkit-Coder' }
CompiledMethod >> gtPackageScope [
	^ self package
]
