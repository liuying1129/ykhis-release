

-- -------------表相关操作---------------

ALTER TABLE treat_master DROP COLUMN patient_birthday;
ALTER TABLE treat_master_bak DROP COLUMN patient_birthday;

ALTER TABLE temp_dir DROP COLUMN DGROUPNO,DROP COLUMN AA;

-- UPDATE treat_slave set if_skin_test='1' WHERE if_skin_test='是';
alter table treat_slave modify column if_skin_test tinyint(1) COMMENT '是否皮试';

-- UPDATE treat_slave_bak set if_skin_test='1' WHERE if_skin_test='是';
alter table treat_slave_bak modify column if_skin_test tinyint(1) COMMENT '是否皮试';

DROP TABLE IF EXISTS `xm`;
DROP TABLE IF EXISTS `tmp003`;
DROP TABLE IF EXISTS `tmp001`;

-- 2021-10-06
alter table treat_slave add COLUMN prescription_no int COMMENT '处方序号';
alter table treat_slave_bak add COLUMN prescription_no int COMMENT '处方序号';

-- -------------函数相关操作---------------



-- -------------存储过程相关操作---------------



-- -------------视图相关操作---------------



-- -------------触发器相关操作---------------

DROP TRIGGER IF EXISTS `tg_patient_info_af_update_pinyin`;

DROP TRIGGER IF EXISTS `tg_patient_info_af_update_tm`;

CREATE TRIGGER `tg_patient_info_af_update_tm` AFTER UPDATE ON `patient_info` FOR EACH ROW UPDATE treat_master 
	set patient_name = NEW.patient_name,
	    patient_sex = NEW.patient_sex,
      patient_age = TIMESTAMPDIFF(YEAR,NEW.patient_birthday,creat_date_time),
			certificate_type = NEW.certificate_type,
			certificate_num = NEW.certificate_num,
			clinic_card_num = NEW.clinic_card_num,
			health_care_num = NEW.health_care_num,
			address = NEW.address,
			work_company = NEW.work_company,
			work_address = NEW.work_address,
			if_marry = NEW.if_marry,
			native_place = NEW.native_place,
			telephone = NEW.telephone
	WHERE patient_unid = NEW.unid
	AND (audit_doctor is NULL or audit_doctor='');

DROP TRIGGER IF EXISTS `tg_treat_master_bf_insert_patient_info`;

DROP TRIGGER IF EXISTS `tg_treat_master_bf_insert_pinyin`;

CREATE TRIGGER `tg_treat_master_bf_insert_pinyin` BEFORE INSERT ON `treat_master` FOR EACH ROW BEGIN	
	SET NEW.patient_pinyin = f_pinyin(@patient_name);
	SET NEW.patient_wbm = f_wbm(@patient_name);
END;

-- -------------数据相关操作---------------
-- 2021-10-06
UPDATE treat_slave set prescription_no=0 WHERE item_type in ('西药','中药') and prescription_no is null;
UPDATE treat_slave_bak set prescription_no=0 WHERE item_type in ('西药','中药') and prescription_no is null;


-- -------------表约束、索引相关操作---------------



-- -------------表关系相关操作---------------



-- -------------重新编译视图---------------
