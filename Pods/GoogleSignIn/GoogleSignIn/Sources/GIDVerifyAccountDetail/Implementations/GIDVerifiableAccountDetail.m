/*
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "GoogleSignIn/Sources/Public/GoogleSignIn/GIDVerifiableAccountDetail.h"

#if TARGET_OS_IOS && !TARGET_OS_MACCATALYST

NSString *const kAccountDetailTypeAgeOver18Scope = @"https://www.googleapis.com/auth/verified.age.over18.standard";

@implementation GIDVerifiableAccountDetail

- (instancetype)initWithAccountDetailType:(GIDAccountDetailType)accountDetailType {
  self = [super init];
  if (self) {
    _accountDetailType = accountDetailType;
  }
  return self;
}

- (nullable NSString *)scope {
  switch (self.accountDetailType) {
    case GIDAccountDetailTypeAgeOver18:
      return kAccountDetailTypeAgeOver18Scope;
    default:
      return nil;
  }
}

- (BOOL)isEqual:(id)object {
  if (![object isKindOfClass:[GIDVerifiableAccountDetail class]]) {
    return NO;
  }
  return self.accountDetailType == ((GIDVerifiableAccountDetail *)object).accountDetailType;
}

- (NSUInteger)hash {
  return self.accountDetailType;
}

+ (GIDAccountDetailType)detailTypeWithString:(NSString *)detailTypeString {
  if ([detailTypeString isEqualToString:kAccountDetailTypeAgeOver18Scope]) {
    return GIDAccountDetailTypeAgeOver18;
  }
  return GIDAccountDetailTypeUnknown;
}

@end

#endif // TARGET_OS_IOS && !TARGET_OS_MACCATALYST
