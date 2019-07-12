Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowse [
	| aCoder aSpace |
		
	aCoder := GtInspector createOnPlayBook: (GtClassCoder forClass: self).
	aSpace := BlSpace new.
	aSpace host: BlOSWindowHost default.
	aSpace title: 'Coder'.
	aSpace extent: 1200@600.
	aSpace addChild: aCoder.
	aSpace withHalos.
	aSpace withSpotter.
	aSpace show
]
