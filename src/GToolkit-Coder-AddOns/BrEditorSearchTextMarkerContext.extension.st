Extension { #name : #BrEditorSearchTextMarkerContext }

{ #category : #'*GToolkit-Coder-AddOns' }
BrEditorSearchTextMarkerContext >> fromCoderViewModel: aCoderViewModel [
	self textSource: (GtTextualCoderViewModelSearchTextSource new textualCoderViewModel: aCoderViewModel)
]
