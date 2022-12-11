Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowseFromButton: anElement [
	"Do we want to share the same coder model?"
	anElement phlow firstParentWithView navigationModel coderDo: [ :aCoder | 
		((GtCoder forCoder: aCoder asNewCoderModelWithSameSubject)
			openInPagerFrom: anElement)
				maximized ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtCopyButtonFor: anAction [
	<gtClassAction>
	^ anAction dropdown
		tooltip: 'Copy Class';
		icon: BrGlamorousVectorIcons changes;
		priority: 4;
		content: [ :aButton | 
			((GtCopyClassForm for: self)
				onAccept: [ :aClass | 
					aButton phlow spawnTool: (GtClassCoderTool forClass: aClass).
					aButton fireEvent: BrDropdownHideWish new ]) asElement
				padding: (BlInsets all: 5) ]
]
