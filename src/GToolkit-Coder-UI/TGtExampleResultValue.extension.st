Extension { #name : #TGtExampleResultValue }

{ #category : #'*GToolkit-Coder-UI' }
TGtExampleResultValue >> asGtExampleResultPreviewElementFor: anExample [

	^ ((GtInspector forObject: self value) exact: 400 @ 400)
		  asScalableElement size: 200 @ 200
]
