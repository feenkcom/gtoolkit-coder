Extension { #name : #PackageTag }

{ #category : #'*GToolkit-Coder-Extensions' }
PackageTag >> gtBrowseFrom: anElement [
	| aTool |

	aTool := self gtDefaultInspectorTool.

	^ BlSpace new
		withCommonSettings;
		inPager: aTool;
		withTitleAndIconOfTool: aTool;
		showFrom: anElement
]
