Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowseFromButton: anElement [
	"Do we want to share the same coder model?"

	anElement phlow coderNavigationModel
		coderDo: [ :aCoder | 
			((GtCoder forCoder: aCoder asNewCoderModelWithSameSubject)
				openInPagerFrom: anElement) maximized ]
]
