Extension { #name : #CompiledMethod }

{ #category : #'*GToolkit-Coder' }
CompiledMethod >> gtBrowseFrom: anElement [
	| classCoder aSpace aCoder |
	classCoder := GtClassCoder forClass: self methodClass.
	aCoder := GtInspector withToolOn: classCoder.
	aSpace := BlSpace new.
	aSpace title: 'Coder'.
	aSpace extent: 1200 @ 600.
	aSpace addChild: aCoder.
	classCoder withSelectedMethod: self.
	aSpace withHalos.
	anElement showSpace: aSpace
]
