Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowseFromButton: anElement [
	"Do we want to share the same coder model?"

	anElement phlow firstParentCoderNavigationModel
		coderDo: [ :aCoder | 
			((GtCoderElement forCoder: aCoder asNewCoderModelWithSameSubject)
				openInPagerFrom: anElement) maximized ]
]
