import 'dart:ui' show Locale;

class FAQ {
  String title;
  String subTtitle;

  FAQ(this.title, this.subTtitle);
}

class TranslationBundle {
  const TranslationBundle(this.parent);
  final TranslationBundle parent;

  String get helloWorld => parent?.helloWorld;

  String get pending => parent?.pending;

  String get completed => parent?.completed;

  String get apartment => parent?.apartment;

  String get villa => parent?.villa;

  List<String> get bookingTabs => parent?.bookingTabs;

  List<List<String>> get additionalFirst => parent?.additionalFirst;

  List<List<List<String>>> get additionalSecond => parent?.additionalSecond;

  List<List<String>> get additionalSecondIssue => parent?.additionalSecondIssue;

  List<String> get clientCategories => parent?.clientCategories;

  List<String> get workerCategories => parent?.workerCategories;

  List<String> get operatorCategories => parent?.operatorCategories;

  String get home => parent?.home;

  String get eletec => parent?.eletec;

  String get bookings => parent?.bookings;

  String get settings => parent?.settings;

  String get support => parent?.support;

  String get signout => parent?.signout;

  List<FAQ> get faqs => parent?.faqs;

  List<String> get userTabs => parent?.userTabs;

  List<String> get staffTabs => parent?.staffTabs;

  List<String> get contractOptions => parent?.contractOptions;

  String get camera => parent?.camera;

  String get gallery => parent?.gallery;

  String get addWhiteList => parent?.addWhiteList;

  String get whiteList => parent?.whiteList;

  String get save => parent?.save;

  String get contract => parent?.contract;

  String get options => parent?.options;

  String get dateOfIssue => parent?.dateOfIssue;

  String get dateOfExpiry => parent?.dateOfExpiry;

  String get description => parent?.description;

  String get userDetail => parent?.userDetail;

  String get delete => parent?.delete;

  String get sure => parent?.sure;

  String get no => parent?.no;

  String get yes => parent?.yes;

  String get enable => parent?.enable;

  String get disable => parent?.disable;

  String get unknow => parent?.unknow;

  String get none => parent?.none;

  String get noData => parent?.noData;

  String get users => parent?.users;

  String get search => parent?.search;

  String get userProfile => parent?.userProfile;

  String get address => parent?.address;

  String get freelancerProfile => parent?.freelancerProfile;

  String get language => parent?.language;

  String get skill => parent?.skill;

  String get workTime => parent?.workTime;

  String get from => parent?.from;

  String get to => parent?.to;

  String get userCategory => parent?.userCategory;

  String get register => parent?.register;

  String get areYou => parent?.areYou;

  String get complete => parent?.complete;

  String get book => parent?.book;

  String get bookingDetail => parent?.bookingDetail;

  String get sameday => parent?.sameday;

  String get earliest => parent?.earliest;

  String get scheduled => parent?.scheduled;

  String get after24 => parent?.after24;

  String get addNewAddr => parent?.addNewAddr;

  String get defaultText => parent?.defaultText;

  String get upload => parent?.upload;

  String get faqsText => parent?.faqsText;

  String get displayName => parent?.displayName;
  
  String get phoneNumber => parent?.phoneNumber;

  String get email => parent?.email;

  String get permission => parent?.permission;

  String get status => parent?.status;

  String get admin => parent?.admin;

  String get customerData => parent?.customerData;

  String get companyData => parent?.companyData;

  String get freelancerData => parent?.freelancerData;

  String get country => parent?.country;

  String get city => parent?.city;

  String get community => parent?.community;

  String get street => parent?.street;

  String get villaNo => parent?.villaNo;

  String get skills => parent?.skills;

  String get times => parent?.times;

  String get clickSave => parent?.clickSave;

  String get bookingInformation => parent?.bookingInformation;

  String get bookingInfo => parent?.bookingInfo;

  String get createTime => parent?.createTime;

  String get startTime => parent?.startTime;

  String get endTime => parent?.endTime;

  String get serviceCode => parent?.serviceCode;

  String get additionalInfo => parent?.additionalInfo;

  String get otherIns => parent?.otherIns;

  String get userInfo => parent?.userInfo;

  String get userName => parent?.userName;

  String get userNumber => parent?.userNumber;

  String get location => parent?.location;

  String get staffName => parent?.staffName;

  String get staffNumber => parent?.staffNumber;

  String get evaluation => parent?.evaluation;

  String get user => parent?.user;

  String get staffInfo => parent?.staffInfo;

  String get staff => parent?.staff;

  String get clickDetail => parent?.clickDetail;

  String get type => parent?.type;

  String get map => parent?.map;

  String get buildName => parent?.buildName;

  String get officeNo => parent?.officeNo;

  String get required => parent?.required;

  String get timeError => parent?.timeError;

  String get name => parent?.name;

  String get operatorText => parent?.operatorText;

  String get assistance => parent?.assistance;

  String get selectDate => parent?.selectDate;

  String get selectAddress => parent?.selectAddress;

  String get cancel => parent?.cancel;

  String get enterManually => parent?.enterManually;

  String get sameDateError => parent?.sameDateError;

  String get workFromTimeError => parent?.workFromTimeError;

  String get workToTimeError => parent?.workToTimeError;
}

//ignore: camel_case_types 
class _Bundle_en extends TranslationBundle {
  const _Bundle_en() : super(null);

  @override
  String get helloWorld => 'Welcome';

  @override
  String get pending => 'Pending';

  @override
  String get completed => 'Completed';

  @override
  String get apartment => 'Apartment';

  @override
  String get villa => 'Villa';

  @override
  List<String> get bookingTabs => [
    'New',
    'Pending', 
    'Completed',
    'Canceled',
    'Deleted',
  ];

  @override
  List<List<String>> get additionalFirst => [
    [ //AC
      'AC cooling repair',
      'AC noise repair',
      'AC digital controller installation',
      'AC controller repair',
      'AC tripping repair',
      'AC leakage repair',
      'AC service',
      'Other custom job e.g new AC unit installation'
    ],
    [ //Electrical
      'Light fixture repair',
      'Power outlets & Switches repair',
      'Light fixture installation',
      'Water heater repair',
      'Other custom job e.g LED installation'
    ],
    [ //Plumbing
      'Water pump or motor repair',
      'Water leakage repair',
      'Small fitting (e.g.faucet) repair',
      'Water tank cleaning',
      'Other custom job e.g outdoor plumbing'
    ],
    [ //Cleaning
      'General cleaning',
      'Floor cleaning or pilishing'
    ]
  ];

  @override
  List<List<List<String>>> get additionalSecond => [
    [ //AC
      [
        'Low cooling',
        'Too much cooling',
        'No cooling',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Bed Room',
        'Kitchen',
        'Living Room',
        'Bath Room',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Reduce electricity bill',
        'Convenience of the remote',
        'Better control over temperature',
        'Display of the controller',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Bed Room',
        'Kitchen',
        'Living Room',
        'Bath Room',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Low cooling and no other reasons',
        'Higher electricity bills',
        'Frequent breakdowns',
        'Reduced life of the compressor',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Bed Room',
        'Kitchen',
        'Living Room',
        'Bath Room',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Dirty air',
        'Low cooling',
        'Using after a long time',
        'Just regular service',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'New AC unit installation',
        'AC unit replacement',
        'AC unit relocation',
        'Other(Provide in Instruction Box / attached photo)'
      ],
    ], 
    [ // Electrical
      [
        'Broken',
        'Not working',
        'Better design',
        'Tripping',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Broken',
        'Not working',
        'Better design',
        'Tripping',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Bedroom',
        'Kitchen',
        'Living Room',
        'Bathroom',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'No or slow heating',
        'Leaking',
        'Overheating',
        'Rusty or discolored water',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Yellow Light',
        'White Ligth',
        'Spiral bright white',
        'LED',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Repair',
        'New installation',
        'Fitting relocation',
        'Other(Provide in Instruction Box / attached photo)'
      ],
    ],
    [ // Plumbing
      [
        'Not starting or jammed',
        'Too noisy',
        'Low or no pressure',
        'Leaking',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Bedroom',
        'Kitchen',
        'Living Room',
        'Bathroom',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Broken',
        'Clogged',
        'Better quality',
        'Leaking',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Regular cleaning',
        'Post construction cleaning',
        'Not cleaned for too long',
        'Water dirty or smelling',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Repair',
        'New installation',
        'Other(Provide in Instruction Box / attached photo)'
      ],
    ],
    [ // Cleaning
      [
        'Regular cleaning',
        'Pre Party cleaning',
        'Post Party cleaning',
        'Other(Provide in Instruction Box / attached photo)'
      ],
      [
        'Ceramic Tiles',
        'Marble',
        'Brick',
        'Other(Provide in Instruction Box / attached photo)'
      ]
    ]
  ];

  @override
  List<List<String>> get additionalSecondIssue => [
    [ //AC
      'What is the issue?',
      'What is the issue?',
      'Reason for installation?',
      'What is the issue?',
      'Reason for coil cleaning?',
      'What is the issue?',
      'What is the issue?',
      'Reason for service?',
      'What is the issue requirement?',
    ],
    [ //Electrical
      'What is the issue?',
      'What is the issue?',
      'Where to install?',
      'What is the issue?',
      'What is the issue?',
      'What is it that you need',
    ],
    [ //Plumbing
      'What is the issue?',
      'Where is the leakage?',
      'What is the issue?',
      'Reason for cleaning',
      'What is it that you need',
    ],
    [ //Cleaning
      'Reason for cleaning?',
      'What is the type of floor?',
    ]
  ];

  @override
  List<String> get clientCategories => [
    'Air Conditioner',
    'Electrical',
    'Plumbing',
    'House Cleaning'
  ];

  @override
  List<String> get workerCategories => [
    'Booking'
  ];

  @override
  List<String> get operatorCategories => [
    'Bookings',
    'Users',
    'WhiteList',
    'Source'
  ];

  @override
  String get home => 'Home';

  @override
  String get eletec => 'Eletec';

  @override
  String get bookings => 'Bookings';

  @override
  String get settings => 'Settings';

  @override
  String get support => 'Support';

  @override
  String get signout => 'Signout';

  @override
  List<FAQ> get faqs => [
    new FAQ('What services do we offer?',
'''
We offer over maintenance services within the following service categories - AC, Plumbing, Electrical, House Cleaning, For more details, kindly visit www.eletec.ae .
'''
    ),
    new FAQ('How do I book a service?',
'''
Customers can book a service using the following methods –
1)Book from our iOS and Android mobile apps.
2)Or give us a call +971 50 307 0781.
We recommend downloading and using our Android and iOS mobile apps, for the best user end-to-end experience.
'''
    ),
    new FAQ('Can I schedule a service for a later date/time?',
'''
Customers can book a Scheduled Service (> 24 hours) offered during standard office hours (8 am to 6 pm) on all working days from Sat to Thu. Such bookings can be scheduled for up to a month in advance. 
'''
    ),
    new FAQ('Are the services available after office hours or Friday or Public Holiday?',
'''
Yes. Our Scheduled Services are offered on Friday or Public Holidays. But there will be a AED200 charge.
'''
    ),
    new FAQ('What is a Same Day Service on the mobile app?',
'''
We offer Same Day Services, for anyone who is flexible on the timing but wants the Service within the day. The same day service does not come with a fixed arrival time commitment but with earliest availability option, within office hours (8 am to 6 pm) on the same day, possibility. You can select on mobile app, to book a Same Day Service. Also, note the Same Day service can only be booked before 12 noon.
'''
    ),
    new FAQ('Do we offer contracts?',
'''
Yes, we have contracts for Annual Maintenance Contracts, which we have 4 options (Economy, Standard, Premium, and Customized Package) as per the client needs. You can find the details in our mobile app, or you can or give us a call +971 50 307 0781.
'''
    ),
    new FAQ('Please explain the 7 Day Service Warranty',
'''
For every service we deliver, we offer a 7-day service warranty which means that if what we fixed is reported faulty again within 7 calendar days, we will come back and try to fix it for free. In case the issue is with the parts and materials, any return on that will be dependent on the warranty that comes from the supplier. Generally parts do not come with a warranty when bought standalone. Also, our Service Warranty is for repair and installation jobs only.
'''
    ),
    new FAQ('How can I reach my assigned Technician after he has been assigned to me?',
'''
Once a Genie has been assigned to a customer, a customer can call the Supervisor of the by calling the number provided in the mobile app. This avoids the hassle of saving numbers for a professional every time you take a home maintenance service. There is no direct calling enabled between the technician and the customer.
'''
    ),
    new FAQ('Can I cancel a booking?',
'''
To cancel a booking, a customer needs to either call or cancel the booking from the app, by clicking on the delete button. For details on cancellation policy, please refer our policy.
'''
    ),
    new FAQ('Can I reschedule a booking?',
'''
You can reschedule a service, following a discussion with the assigned Supervisor of the technician.
'''
    ),
    new FAQ('How and when do I pay for a service?',
'''
You can pay for a service by a credit card/ debit card, account transfer or in cash upon completion of your job or as advance if the job requires an advance payment. Advance payment is generally required for jobs which need procurement of parts and materials.
'''
    ),
    new FAQ('How can I leave feedback or raise a complaint?',
'''
As a customer, you can evaluate or leave a feedback from the mobile app: Bookings -> Select booked service -> Below you will find Evaluation, select the necessary option from Not Satisfied to Very Satisfied and you can optional write you comment and click Save.
'''
    ),
  ];

  @override
  List<String> get userTabs => [
    'STAFF',
    'FREELANCER',
    'OPERATOR',
    'CUSTOMER',
    'COMPANY'
  ];

  @override
  List<String> get staffTabs => [
    'STAFF',
    'FREELANCER'
  ];

  @override
  List<String> get contractOptions => [
    'Economy',
    'Standard',
    'Premium',
    'Customized'
  ];

  @override
  String get camera => 'Camera';

  @override
  String get gallery =>  'Gallery';

  @override
  String get addWhiteList => 'Add White List';

  @override
  String get whiteList =>  'White List';

  @override
  String get save => 'Save';

  @override
  String get contract => 'Contract';

  @override
  String get options => 'Options';

  @override
  String get dateOfIssue => 'Date of issue';

  @override
  String get dateOfExpiry => 'Date of expiry';

  @override
  String get description => 'Description';

  @override
  String get userDetail => 'User Detail';

  @override
  String get delete => 'Delete';

  @override
  String get sure => 'Are you sure?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get enable => 'Enable';

  @override
  String get disable => 'Disable';

  @override
  String get unknow => 'Unknown';

  @override
  String get none => 'None';

  @override
  String get noData => 'No data retrieved';

  @override
  String get users => 'Users';
  
  @override
  String get search => 'Search';

  @override
  String get userProfile => 'User Profile';

  @override
  String get address => 'Address';

  @override
  String get freelancerProfile => 'Freelancer Profile';

  @override
  String get language => 'Language';

  @override
  String get skill => 'Skill';

  @override
  String get workTime => 'Working Time';

  @override
  String get from => 'from';

  @override
  String get to => 'to';

  @override
  String get userCategory => 'User Category';

  @override
  String get register => 'REGISTRATION';

  @override
  String get areYou => 'Are you ?';

  @override
  String get complete => 'Complete';

  @override
  String get book => 'Book';

  @override
  String get bookingDetail => 'BookingDetail';

  @override
  String get sameday => 'Sameday';

  @override
  String get earliest => '(Earliest available)';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get after24 => '(After 24 hours)';

  @override
  String get addNewAddr => 'Add New Address';

  @override
  String get defaultText => 'Default';

  @override
  String get upload => 'Upload Photo(Optional)';

  @override
  String get faqsText => 'FAQs';

  @override
  String get displayName => 'Name';
  
  @override
  String get phoneNumber => 'PhoneNumber';

  @override
  String get email => 'Email';

  @override
  String get permission => 'Permission';

  @override
  String get status => 'Status';

  @override
  String get admin => 'Admin';

  @override
  String get customerData => 'Customer Data';

  @override
  String get companyData => 'Company Data';

  @override
  String get freelancerData => 'Freelancer Data';

  @override
  String get country => 'Country';

  @override
  String get city => 'City';

  @override
  String get community => 'Community';

  @override
  String get street => 'StreetName';

  @override
  String get villaNo => 'Villa No.';

  @override
  String get skills => 'skills';

  @override
  String get times => 'times';

  @override
  String get clickSave => 'Click to Save';

  @override
  String get bookingInformation => 'Booking Information';

  @override
  String get bookingInfo => 'Booking Info';

  @override
  String get createTime => 'Create Time';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get serviceCode => 'Service Code';

  @override
  String get additionalInfo => 'Additional Info';

  @override
  String get otherIns => 'Other Instruction';

  @override
  String get userInfo => 'User Information';

  @override
  String get userName => 'User Name';

  @override
  String get userNumber => 'User Number';

  @override
  String get location => 'Location';

  @override
  String get staffName => 'Staff Name';

  @override
  String get staffNumber => 'Staff Number';

  @override
  String get evaluation => 'Evaluation';

  @override
  String get user => 'User';

  @override
  String get staffInfo => 'Staff Info';

  @override
  String get staff => 'Staff';

  @override
  String get clickDetail => 'Click to Detail';

  @override
  String get type => 'Type';

  @override
  String get map => 'Map';

  @override
  String get buildName => 'BuildingName';

  @override
  String get officeNo => 'OfficeNo.';

  @override
  String get required => 'This field is required!';

  @override
  String get timeError => 'Time Error';

  @override
  String get name => 'Name';

  @override
  String get operatorText => 'Operator';

  @override
  String get assistance => 'Need Assistance?';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectAddress => 'Select Address';

  @override
  String get cancel => 'Cancel';

  @override
  String get enterManually => 'Enter Manually';

  @override
  String get sameDateError => 'Must be before AM 12:00 on the day';

  @override
  String get workFromTimeError => 'Working time AM 8: 00';

  @override
  String get workToTimeError => 'Working time PM 6: 00';
}

//ignore: camel_case_types 
class _Bundle_ar extends TranslationBundle {
  const _Bundle_ar() : super(null);

  @override
  String get helloWorld => 'مرحبا بكم'; 

  @override
  String get pending => 'قيد الإنجاز'; 

  @override
  String get completed => 'أنجز';  

  @override
  String get apartment => 'شقة';  

  @override
  String get villa => 'فيلا';

  @override
  List<String> get bookingTabs => [
    'جديد', 
    'قيد الإنجاز', 
    'انجز',
    'إلغاء',
    'حذف', 
  ];

  @override
  List<List<String>> get additionalFirst => [
    [ //AC
      'إصلاح أعطال التبريد للمكييف', 
      'إصلاح أعطال الضجيج المكييف', 
      'تركيب وحدة تحكم رقمية جديدة للمكييف', 
      'إصلاح وحدة تحكم للمكييف', 
      'إصلاح التوقف المفاجأ للمكيييف',
      'إصلاح أعطال التسريب للمكييف', 
      'خدمة  صيانة عامة للمكييف',  
      'أعطال أخرى' 
    ],
    [ //Electrical
      'إصلاح إضاءات', 
      'إصلاح مفاتيح الكهرباء', 
      'تركيب إضاءات', 
      'إصلاح سخان الماء', 
      'أعمال أخرى حسب الطلب' 
    ],
    [ //Plumbing
      'إصلاح مضخة الماء', 
      'إصلاح أعطال تسرب المياه', 
      'أعمال إصلاح وتركيب بسيطة', 
      'تنظيف خزان الماء', 
      'أعمال أخرى حسب الطلب'
    ], 
    [ //Cleaning
      'تنظيف عام', 
      'تنظيف وتلميع  الأرضيات' 
    ]
  ];

  @override
  List<List<List<String>>> get additionalSecond => [
    [ //AC
      [
        'تبريد منخفض',
        'تبريد عالي',
        'لا يوجد تبريد',
        'أرفق صور إن وجد'
      ],
      [
        'غرفة نوم', 
        'مطبخ',
        'صالة',
        'حمام',
        'أرفق صور إن وجد'
      ],
      [
        'تقليل استهلاك الكهرباء',
        'سهول التحكم', 
        'تحكم افضل لدرجة الحرارة', 
        'عرض الشاشة', 
        'أرفق صور إن وجد'
      ],
      [
        'غرفة نوم', 
        'مطبخ',
        'صالة',
        'حمام',
        'أرفق صور إن وجد'
      ],
      [
        'تبريد اقل أو اسباب اخرى', 
        'إستهلاك عالي للكهرباء',
        'اعطال دائمة',
        'انتهاء عمر الإفتراضي للكمبرسيسور',  
        'أرفق صور إن وجد'
      ],
      [
        'غرفة نوم', 
        'مطبخ',
        'صالة',
        'حمام',
        'أرفق صور إن وجد'
      ],
      [
        'غرفة', 
        'أكثر عن غرفة',
        'توقف عن العمل نهائيا',
        'أرفق صور إن وجد'
      ],
      [
        'هواء ملوث', 
        'تبريد منخفض',
        'تشغيل بعد فترة طويلة', 
        'خدمة دورية',
        'أرفق صور إن وجد'
      ],
      [
        'تركيب دكتات جديدة', 
        'تركيب وحدة جديدة',
        'تغيير مكان الوحدة',
        'أرفق صور إن وجد'
      ],
    ], 
    [ // Electrical
      [
        'مكسور ولا يعمل', 
        'عطلان ولا يعمل',
        'تصميم وموديل افضل',
        'يعمل أحيانا ويتوقف',
        'أرفق صور إن وجد'
      ],
      [
        'مكسور ولا يعمل', 
        'عطلان ولا يعمل',
        'تصميم وموديل افضل',
        'يعمل أحيانا ويتوقف', 
        'أرفق صور إن وجد'
      ],
      [
        'غرفة نوم', 
        'مطبخ',
        'صالة',
        'حمام',
      'أرفق صور إن وجد'
      ],
      [
        'لا يوجد تسخين',
        'تسريب ماء',
        'تسخين عالي',
        'صدء وانسدادات', 
        'أرفق صور إن وجد'
      ],
      [
        'إضاءة صفراء',
        'إضاءة بيضاء',
        'أضاءة حلزونية بيضاء',
        'أل أي دي',
        'أرفق صور إن وجد'
      ],
      [
        'تصليح',
        'تركيب جديد',
        'تغير موقع الوحدة',
        'أرفق صور إن وجد'
      ],
    ],
    [ // Plumbing
      [
        'لا يعمل أويوجد انسداد',
        'صوت مزعج',
        'ضغط منخفض',
        'تسريب مياة',
        'أرفق صور إن وجد'
      ],
      [
        'غرفة نوم', 
        'مطبخ',
        'صالة',
        'حمام',
        'أرفق صور إن وجد'
      ],
      [
        'مكسور',
        'انسداد',
        'جودة افضل',
        'تسريب مياة',
        'أرفق صور إن وجد'
      ],
      [
        'تنظيف دوري',
        'تنظيف بعد انتهاء البناء',
        'لم يتم التنظيف لفترة طويلة',
        'المياة غير نظيفة وبها رائحة',
        'أرفق صور إن وجد'
      ],
      [
        'إصلاح', 
        'تركيب جديد', 
        'أرفق صور إن وجد'
      ],
    ],
    [ // Cleaning
      [
        'تنظيف دوري', 
        'تنظيف قبل المناسبات',
        'تنظيف بعد انتهاء من المناسبات',
        'أرفق صور إن وجد'
      ],
      [
        'بلاط السيراميك', 
        'رخام', 
        'طابوق', 
        'أرفق صور إن وجد'
      ]
    ]
  ];

  @override
  List<List<String>> get additionalSecondIssue => [
    [ //AC
      'ما هي المشكلة؟', 
      'ما هي المشكلة؟', 
      'سبب التركيب؟', 
      'ما هي المشكلة؟', 
      'سبب لتنظيف الملف؟', 
      'ما هي المشكلة؟', 
      'ما هي المشكلة؟', 
      'سبب طلب الخدمة؟', 
      'ما هي متطلبات المشكلة؟', 
    ],
    [ //Electrical
      'ما هي المشكلة؟', 
      'ما هي المشكلة؟', 
      'مكان التركيب؟', 
      'ما هي المشكلة؟', 
      'ما هي المشكلة؟ ', 
      'ما الذي تحتاجه؟', 
    ],
    [ //Plumbing
      'ما هي المشكلة؟', 
      'مكان التسريب؟', 
      'ما هي المشكلة؟', 
      'سبب طلب  التنظيف؟', 
      'ما الذي تحتاجه؟', 
    ],
    [ //Cleaning
      'سبب طلب  التنظيف؟', 
      'ما هي نوعية الأرضية؟', 
    ]
  ];

  @override
  List<String> get clientCategories => [
    'مكييف الهواء', 
    'الكهرباء', 
    'أنابيب المياه', 
    'تنظيف المنزل' 
  ];

  @override
  List<String> get workerCategories => [
    'حجز' 
  ];

  @override
  List<String> get operatorCategories => [
    'حجوزات', 
    'مستخدمين', 
    'قائمة',
    'رفع'
  ];

  @override
  String get home => 'قائمة الرئيسية'; 

  @override
  String get eletec => 'Eletec';

  @override
  String get bookings => 'حجز';

  @override
  String get settings => 'إعدادات'; 

  @override
  String get support => 'الدعم الفني';

  @override
  String get signout => 'خروج';

  @override
  List<FAQ> get faqs => [
    new FAQ(' ما هي الخدمات التي نوفرها؟', 
'''
نحن نوفر خدمات الصيانة من فئات متنوعة منها : اجهزة التكييف, أنابيب المياه, الكهرباء, تنظيف المنزل. لمزيد من التفاصيل يرجى زيارة. 
'''
    ),
    new FAQ('كيف أقوم بحجز خدمة؟',
'''
يمكن للعملاء حجز خدمة من خلال الخطوات التالية:
حجز من خلال تطبيقات الموبايل 
اتصال على الرقم +971503070781
نوصى بتحميل و استخدام برنامجنا في نظامين الاندرويد و الاي او اس للحصول على أفضل تجربة للمستخدم
'''
    ),
    new FAQ('هل يمكنني جدولة الخدمة لتاريخ أو وقت لاحق؟',
'''
العملاء يستطيعون حجز جدول الخدمة 24 ساعة خلال أوقات الدوام للمكتب ( 8 صباحا إلى 6 مساءا) في أيام العمل من السبت إلى الخميس يمكن جدولة مثل هذه الحجوزات لمدة تصل إلى شهرمقدما.
'''
    ),
    new FAQ('هل الخدمات متاحة بعد أوقات العمل أو يوم الجمعة أوعطلة رسمية؟',
'''
نعم, جدول خدماتنا متاحة في يوم الجمعة أو عطلة رسمية, ولكن سيكون هناك رسوم إضافية قيمتها 200 درهم.
'''
    ),
    new FAQ('ما هي خدمة نفس اليوم الموجود في تطبيق الهاتف؟',
'''
نحن نوفر خدمات عاجلة " نفس اليوم " لأي عميل لديه أوقات مرنه و يحتاج الخدمة عاجلة في نفس اليوم. خدمة نفس اليوم لا تأتي بأوقات محددة ولكن خيار أقرب وقت ممكن التواجد في غضون الساعة 8 صباحا حتى 6 مساءا في نفس اليوم ويمكن حجز الخدمة عن طريق تطبيق المتاح من الشركةخلال 12 ساعة.
'''
    ),
    new FAQ('هل تقدمون العقود؟', 
'''
نعم, نحن نقدم عقود صيانة سنوية ولدينا 4 خيارات منها اقتصاد و اساسي و ممتاز و حزمة مخصصة حسب حاجة العميل, تستطيع الحصول على تفاصيل من تطبيق الهاتف أو الاتصال على الرقم +971503070781  
'''
    ),
    new FAQ('يرجى توضيح ضمان خدمة 7 أيام؟', 
'''
لكل خدمة نقدمها, نقدم ضمان خدمة لمدة 7 أيام و سوف نعود و نحاول إصلاحه مجانا في حال المشكلة في الأجزاء أو مواد أي عائد على ذلك يعتمد على الضمان الذي يأتي من المورد. عموما الأجزاء المستقلة لا تأتي مع الضمان عندما نشتريه أيضا ضمان خدمتنا هو لإصلاح و التركيب فقط. 
'''
    ),
    new FAQ('كيف يمكنني الوصول إلى الفني المخصص لي بعد تعيينه لي؟',
'''
 مجرد تعيين أحد لعميل ، يمكن للعميل الاتصال بالمشرف على الهاتف عن طريق الاتصال بالرقم المقدم في تطبيق الجوال. هذا يتجنب الازعاج من الادخار للأرقام المهنية في كل مرة تقوم فيها بخدمة الصيانة المنزلية. لا يوجد اتصال مباشر ممكّن بين الفني والعميل.

'''
    ),
    new FAQ('هل يمكنني إلغاء الحجز؟', 
'''
لإلغاء الحجز ، يحتاج العميل إما إلى الاتصال أو إلغاء الحجز من التطبيق ، من خلال النقر على زر الإلغاء. للحصول على تفاصيل حول سياسة الإلغاء ، يرجى الرجوع إلى سياستنا.
'''
    ),
    new FAQ('هل يمكنني إعادة جدولة الحجز؟', 
'''
يمكنك إعادة جدولة خدمة ، بعد مناقشة مع المشرف المعين للفني.
'' '
'''
    ),
    new FAQ('؟ كيف ومتى أدفع مقابل الخدمة',
'''
يمكنك الدفع مقابل الخدمة عن طريق بطاقة الائتمان ، أو تحويل الحساب أو نقدًا عند الانتهاء من وظيفتك أو مقدمًا إذا كانت الوظيفة تتطلب دفعة مسبقة. الدفع المسبق مطلوب بشكل عام للوظائف التي تحتاج إلى شراء قطع الغيار والمواد.
'''
    ),
    new FAQ('كيف يمكنني ترك تعليق أو رفع شكوى؟', 
'''
باعتبارك عميلاً ، يمكنك تقييم وكتابة تعليق للخدمة التي تلقيتها مباشرةً من تطبيق الجوّال. بدلاً من ذلك ، يمكنك الاتصال بنا أو مراسلتنا على أيٍّ من تفاصيل الاتصال أو عنصر الدعم في تطبيق الجوال.
'''
    ),
  ];

  @override
  List<String> get userTabs => [
    'الموظف', 
    'الموظف المستقل', 
    'الإداري', 
    'العميل', 
    'الشركة' 
  ];

  @override
  List<String> get staffTabs => [
    'الموظف', 
    'الموظف المستقل' 
  ];

  @override
  List<String> get contractOptions => [
    'Economy',
    'Standard',
    'Premium',
    'Customized'
  ];

  @override
  String get camera => 'كاميرا'; 

  @override
  String get gallery =>  'استوديو'; 

  @override
  String get addWhiteList => 'إضافة إلى القائمة البيضاء';

  @override
  String get whiteList =>  'القائمة البيضاء'; 

  @override
  String get save => 'حفظ'; 

  @override
  String get contract => 'عقد'; 

  @override
  String get options => 'خيارات'; 

  @override
  String get dateOfIssue => 'تاريخ الأصدار'; 

  @override
  String get dateOfExpiry => 'تاريخ الانتهاء'; 

  @override
  String get description => 'وصف'; 

  @override
  String get userDetail => 'تفاصيل المستخدم'; 

  @override
  String get delete => 'حذف'; 

  @override
  String get sure => 'هل أنت متأكد؟'; 

  @override
  String get no => 'لا'; 

  @override
  String get yes => 'نعم'; 

  @override
  String get enable => 'تمكين'; 

  @override
  String get disable => 'إيقاف'; 

  @override
  String get unknow => 'غير معروف'; 

  @override
  String get none => 'لا يوجد'; 

  @override
  String get noData => 'لا توجد بيانات استرجاعها'; 

  @override
  String get users => 'مستخدمين'; 
  
  @override
  String get search => 'بحث'; 

  @override
  String get userProfile => 'ملف تعريفي للمستخدم'; 

  @override
  String get address => 'العنوان'; 

  @override
  String get freelancerProfile => 'ملف تعريفي مستقل'; 

  @override
  String get language => 'اللغة'; 

  @override
  String get skill => 'مهارات'; 

  @override
  String get workTime => 'أوقات العمل'; 

  @override
  String get from => 'من'; 

  @override
  String get to => 'إلى'; 

  @override
  String get userCategory => 'فئة المستخدم'; 

  @override
  String get register => 'تسجيل'; 

  @override
  String get areYou => 'هل أنت؟';

  @override
  String get complete => 'أنجز'; 

  @override
  String get book => 'المقرر'; 

  @override
  String get bookingDetail => 'تفاصيل الحجز'; 

  @override
  String get sameday => 'نفس اليوم'; 

  @override
  String get earliest => '(أقرب وقت ممكن)'; 

  @override
  String get scheduled => 'جدول'; 

  @override
  String get after24 => '(بعد 24 ساعة)'; 

  @override
  String get addNewAddr => 'إضافة عنوان جديد'; 

  @override
  String get defaultText => 'الحالة الطبيعية'; 

  @override
  String get upload => 'إرفاق صورة'; 

  @override
  String get faqsText => 'أسئلة الأكثر تكرارا'; 

  @override
  String get displayName => 'الاسم'; 
  
  @override
  String get phoneNumber => 'رقم الهاتف'; 

  @override
  String get email => 'البريد الإلكتروني'; 

  @override
  String get permission => 'تصريح';

  @override
  String get status => 'الحالة'; 

  @override
  String get admin => 'إداري'; 

  @override
  String get customerData => 'تفاصيل العميل'; 

  @override
  String get companyData => 'تفاصيل الشركة'; 

  @override
  String get freelancerData => 'تفاصيل الموظف المستقلة'; 

  @override
  String get country => 'الدولة'; 

  @override
  String get city => 'المدينة'; 

  @override
  String get community => 'مجتمع'; 

  @override
  String get street => 'اسم الشارع'; 

  @override
  String get villaNo => 'رقم الشقة/فيلا'; 

  @override
  String get skills => 'مهارات'; 

  @override
  String get times => 'أوقات'; 

  @override
  String get clickSave => 'اضغط لحفظ';

  @override
  String get bookingInformation => 'معلومات الحجز'; 

  @override
  String get bookingInfo => 'تفاصيل الحجز'; 

  @override
  String get createTime => 'إختيار الوقت'; 

  @override
  String get startTime => 'وقت البدء'; 

  @override
  String get endTime => 'وقت الانتهاء'; 

  @override
  String get serviceCode => 'رمز الخدمة'; 

  @override
  String get additionalInfo => 'اختيار تفاصيل إضافية'; 

  @override
  String get otherIns => 'تعليمات أخرى'; 

  @override
  String get userInfo => 'معلومات المستخدم'; 

  @override
  String get userName => 'اسم المستخدم'; 

  @override
  String get userNumber => 'رقم المستخدم'; 

  @override
  String get location => 'الموقع'; 

  @override
  String get staffName => 'اسم الموظف'; 

  @override
  String get staffNumber => 'رقم االوظيفي'; 

  @override
  String get evaluation => 'تقييم'; 

  @override
  String get user => 'مستخدم'; 

  @override
  String get staffInfo => 'معلومات الموظف'; 

  @override
  String get staff => 'الموظف'; 

  @override
  String get clickDetail => 'اضغط للحصول على التفاصيل';

  @override
  String get type => 'أكتب'; 

  @override
  String get map => 'خريطة'; 

  @override
  String get buildName => 'اسم المبنى'; 

  @override
  String get officeNo => 'رقم المكتب'; 

  @override
  String get required => 'هذه الخانة مطلوبة'; 

  @override
  String get timeError => 'خطأ في إختيار الوقت'; 

  @override
  String get name => 'اسم'; 

  @override
  String get operatorText => 'اداري'; 

  @override
  String get assistance => 'تحتاج مساعدة؟'; 

  @override
  String get selectDate => 'حدد تاريخ';

  @override
  String get selectAddress => 'اختر العنوان';

  @override
  String get cancel => 'إلغاء';

  @override
  String get enterManually => 'أدخل يدويا';

  @override
  String get sameDateError => 'يجب أن يكون قبل الساعة 12:00 ظهراً في اليوم';

  @override
  String get workFromTimeError => 'وقت العمل صباحا 8: 00';

  @override
  String get workToTimeError => 'وقت العمل الساعة 6:00';
}

TranslationBundle translationBundleForLocale(Locale locale) {
  switch (locale.languageCode) {
    case 'ar':
      return const _Bundle_ar();
    case 'en':
      return const _Bundle_en();
  }
  return const TranslationBundle(null);
}
